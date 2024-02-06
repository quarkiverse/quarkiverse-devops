///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Bump the JDK version in the GitHub Actions workflow file
 */
public class BumpToJDK17 {

    public static void main(String... args) throws Exception {
        // Update snapshot workflow
        {
            Path workflowFile = Path.of(".github/workflows/quarkus-snapshot.yaml");
            if (Files.exists(workflowFile)) {
                Files.writeString(workflowFile,
                        Files.readString(workflowFile).replace("JAVA_VERSION: 11", "JAVA_VERSION: 17"));
            }
        }
        // Update release workflow
        {
            Path workflowFile = Path.of(".github/workflows/release.yml");
            if (Files.exists(workflowFile)) {
                String contents = Files.readString(workflowFile);
                Files.writeString(workflowFile, contents.replace("JDK 11", "JDK 17").replace("java-version: 11", "java-version: 17"));
            }
        }
        // Update build.yaml as well
        {
            Path workflowFile = Path.of(".github/workflows/build.yml");
            if (Files.exists(workflowFile)) {
                String contents = Files.readString(workflowFile);
                Files.writeString(workflowFile, contents.replace("JDK 11", "JDK 17").replace("java-version: 11", "java-version: 17"));
            }
        }
    }
}
