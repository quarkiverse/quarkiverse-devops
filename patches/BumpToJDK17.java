///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Bump the JDK version in the GitHub Actions workflow file
 */
public class BumpToJDK17 {

    public static void main(String... args) throws Exception {
        Path workflowFile = Path.of(".github/workflows/quarkus-snapshot.yaml");
        if (Files.exists(workflowFile)) {
            Files.writeString(workflowFile,
                    Files.readString(workflowFile).replace("JAVA_VERSION: 11", "JAVA_VERSION: 17"));
        }
    }
}
