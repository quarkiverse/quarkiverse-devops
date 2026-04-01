/// usr/bin/env jbang "$0" "$@" ; exit $?

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class AdjustWorkflowPermissions {

    public static void main(String... args) throws Exception {
        insertPermissions(Path.of(".github/workflows/build.yml"), """
                permissions:
                  contents: read
                  pull-requests: read
                ""","concurrency:");
        insertPermissions(Path.of(".github/workflows/pre-release.yml"), """
                permissions:
                  contents: read
                  pull-requests: read
                """, "concurrency:");

        insertPermissions(Path.of(".github/workflows/quarkus-snapshot.yaml"), """
                permissions:
                  contents: read

                concurrency:
                  group: ${{ github.workflow }}-${{ github.ref }}
                  cancel-in-progress: true

                defaults:
                  run:
                    shell: bash
                ""","jobs:");
        insertPermissions(Path.of(".github/workflows/release-prepare.yml"), """
                permissions:
                  contents: read
                """, "concurrency:");
    }

    private static void insertPermissions(Path workflowFile, String permissions, String before) throws IOException {
        if (Files.exists(workflowFile)) {
            String fileContents = Files.readString(workflowFile);
            // Add the content before the 'concurrency:' section
            fileContents = fileContents.replace(before, permissions + "\n" + before);
            // Write the contents back to the file
            Files.writeString(workflowFile, fileContents);
        }
    }

}
