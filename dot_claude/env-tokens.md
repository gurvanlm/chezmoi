# Environment tokens available

The following authentication tokens are exposed as environment variables in
the shell session and may be used to call internal services without prompting
the user for credentials.

## `GITLAB_TOKEN`

Personal access token for **gitlab.edgemind.net** (Edgemind internal GitLab).

Use it as the `PRIVATE-TOKEN` header on the GitLab REST API.

> ⚠️ **TOUJOURS** identifier les projets par leur **ID numérique**, jamais par
> leur nom/chemin. Pour créer une MR ou faire n'importe quel appel API GitLab,
> récupérer d'abord l'ID numérique du projet (ex:
> `curl ... "https://gitlab.edgemind.net/api/v4/projects?search=<nom>"` →
> champ `id`), puis utiliser cet entier dans l'URL :
> `/api/v4/projects/<ID>/merge_requests`. Ne pas utiliser le chemin
> path-encodé `<group%2Fproject>`.

Examples:

```bash
# Resolve the numeric project id first (NEVER use the name/path directly)
curl -sS --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     "https://gitlab.edgemind.net/api/v4/projects?search=<nom>"   # -> field "id"

# Create a Merge Request on a project (numeric id)
curl -sS --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     --data-urlencode "source_branch=<branch>" \
     --data-urlencode "target_branch=<target>" \
     --data-urlencode "title=<title>" \
     --data-urlencode "description=<markdown body>" \
     "https://gitlab.edgemind.net/api/v4/projects/<ID>/merge_requests"

# Inspect a project / list MRs / fetch a pipeline (numeric id)
curl -sS --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     "https://gitlab.edgemind.net/api/v4/projects/<ID>"
```

`glab` is **not** installed; use `curl` directly against the REST API. If a
future task warrants it, suggest installing `glab` and configuring
`GITLAB_HOST=gitlab.edgemind.net` + `GITLAB_TOKEN=$GITLAB_TOKEN`.

## `SONAR_TOKEN`

Authentication token for the internal **SonarQube** server.

Pair it with `SONAR_HOST_URL` (also typically set in CI variables, but may not
be in your local shell — check before calling). Used by `mvn sonar:sonar`:

```bash
mvn sonar:sonar -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.token=$SONAR_TOKEN
```

Or to query the Sonar web API directly:

```bash
curl -sS -u "$SONAR_TOKEN:" "$SONAR_HOST_URL/api/projects/search"
```

## Handling

- Never echo or log the raw token value. Redact when surfacing env contents
  to the user.
- If a token is missing from the env in a fresh shell, ask the user to source
  their profile rather than guessing the value.
