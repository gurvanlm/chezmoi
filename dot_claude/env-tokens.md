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

Authentication token for the internal **SonarQube** server
(`https://sonarqube.edgemind.net`, version 26.4 as of 2026-07-28).

`SONAR_HOST_URL` is a **CI-only** variable — it is *not* in the local shell,
so pass the URL explicitly when calling from a dev machine.

> ⚠️ **`mvn sonar:sonar` no longer works** — anywhere, CI or local. SonarSource
> removed the `sonar` prefix alias that resolved via the legacy
> `org.codehaus.mojo:sonar-maven-plugin` relocation; the entry disappeared from
> the group `maven-metadata.xml` on Maven Central around 2026-07-24, and Maven
> then fails with `No plugin found for prefix 'sonar'`. Declaring the plugin in
> a pom does **not** fix it (verified on ibf: neither `build/plugins` nor
> `pluginManagement`, neither root nor parent-pom — plugin prefixes resolve only
> against the session's `pluginGroups`, which come from `settings.xml`).
> Use **fully-qualified coordinates**, which is also what SonarSource's own docs
> show first:

```bash
mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:5.7.0.6970:sonar \
    -Dsonar.host.url=https://sonarqube.edgemind.net -Dsonar.token=$SONAR_TOKEN
```

> ⚠️ Running that locally **publishes a real analysis** to the shared project
> and, without `-Dsonar.branch.name=<branch>`, overwrites the main branch's
> analysis with the state of your working tree. Prefer the IDE extension in
> connected mode for day-to-day feedback; let CI do the publishing.

Or to query the Sonar web API directly:

```bash
curl -sS -u "$SONAR_TOKEN:" "https://sonarqube.edgemind.net/api/projects/search"
```

## Handling

- Never echo or log the raw token value. Redact when surfacing env contents
  to the user.
- If a token is missing from the env in a fresh shell, ask the user to source
  their profile rather than guessing the value.
