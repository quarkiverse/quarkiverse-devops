///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Converts the quarkus-snapshot.yaml workflow to use the reusable workflow from quarkiverse/.github
 */
public class UpdateSnapshotWorkflow {

    public static void main(String... args) throws Exception {
        Path workflowFile = Path.of(".github/workflows/quarkus-snapshot.yaml");
        if (!Files.exists(workflowFile)) {
            System.out.println("No quarkus-snapshot.yaml found, skipping");
            return;
        }
        String content = Files.readString(workflowFile);

        // Skip if already using the reusable workflow
        if (content.contains("quarkiverse/.github/.github/workflows/quarkus-ecosystem-ci.yml")) {
            System.out.println("Already using the reusable workflow, skipping");
            return;
        }

        // Extract JAVA_VERSION
        Matcher javaVersionMatcher = Pattern.compile("JAVA_VERSION:\\s*(\\S+)").matcher(content);
        if (!javaVersionMatcher.find()) {
            System.out.println("Could not find JAVA_VERSION in workflow file, skipping");
            return;
        }
        String javaVersion = javaVersionMatcher.group(1);

        // Extract ECOSYSTEM_CI_REPO_PATH
        Matcher repoPathMatcher = Pattern.compile("ECOSYSTEM_CI_REPO_PATH:\\s*(\\S+)").matcher(content);
        if (!repoPathMatcher.find()) {
            System.out.println("Could not find ECOSYSTEM_CI_REPO_PATH in workflow file, skipping");
            return;
        }
        String repoPath = repoPathMatcher.group(1);

        System.out.println("Found JAVA_VERSION: " + javaVersion);
        System.out.println("Found ECOSYSTEM_CI_REPO_PATH: " + repoPath);

        String newContent = """
                name: "Quarkus ecosystem CI"
                on:
                  workflow_dispatch:
                  watch:
                    types: [started]

                concurrency:
                  group: ${{ github.workflow }}-${{ github.ref }}
                  cancel-in-progress: true

                defaults:
                  run:
                    shell: bash

                jobs:
                  build:
                    uses: quarkiverse/.github/.github/workflows/quarkus-ecosystem-ci.yml@main
                    secrets: inherit
                    with:
                      ecosystem_ci_repo_path: %s
                      java_version: %s
                """.formatted(repoPath, javaVersion);

        Files.writeString(workflowFile, newContent);
        System.out.println("Updated " + workflowFile);
    }
}
