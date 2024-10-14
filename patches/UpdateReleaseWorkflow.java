/// usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class UpdateReleaseWorkflow {

    public static void main(String... args) throws Exception {
        // Update the release workflow
        Path releaseWorkflow = Path.of(".github/workflows/release.yml");
        Path preRelease = Path.of(".github/workflows/pre-release.yml");
        Path releasePrepare = Path.of(".github/workflows/release-perform.yml");
        Path releasePerform = Path.of(".github/workflows/release-prepare.yml");
        System.out.println("-> RELEASE WORKFLOW EXISTS? " + Files.exists(releaseWorkflow));
        if (Files.deleteIfExists(releaseWorkflow)) {
            System.out.println("Copying");
            Files.copy(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jgit/.github/workflows/pre-release.yml"), preRelease, StandardCopyOption.REPLACE_EXISTING);
            Files.copy(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jgit/.github/workflows/release-prepare.yml"), releasePrepare);
            Files.copy(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jgit/.github/workflows/release-perform.yml"), releasePerform);
        }
    }
}
