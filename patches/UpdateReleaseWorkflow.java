///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;

public class UpdateReleaseWorkflow {

    public static void main(String... args) throws Exception {

        // Update the release workflow
        Path releaseWorkflow = Path.of(".github/workflows/release.yml");
        if (Files.exists(releaseWorkflow)) {
            // TODO: use an URL
            Files.write(releaseWorkflow, Files.readAllBytes(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jsch/.github/workflows/release.yml")));
        }
    }
}
