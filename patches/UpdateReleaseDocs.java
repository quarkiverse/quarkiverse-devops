///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class UpdateReleaseDocs {

    public static void main(String... args) throws Exception {
        // Update the release workflow
        Path releaseWorkflow = Path.of(".github/workflows/release.yml");
        if (Files.exists(releaseWorkflow)) {
            String fileContents = Files.readString(releaseWorkflow, StandardCharsets.UTF_8);
            fileContents = fileContents.replace("/attributes.adoc", "");
            Files.writeString(releaseWorkflow, fileContents);
        }
    }
}
