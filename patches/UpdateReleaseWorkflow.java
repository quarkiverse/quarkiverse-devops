/// usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.stream.Stream;

public class UpdateReleaseWorkflow {

    public static void main(String... args) throws Exception {
        // Update the release workflow
        Path releasePrepare = Path.of(".github/workflows/release-prepare.yml");
        Path releasePerform = Path.of(".github/workflows/release-perform.yml");
        if (Files.exists(releasePrepare) && Files.exists(releasePerform)) {
            try (Stream<String> lines = Files.lines(releasePerform)) {
                if (lines.anyMatch(line -> line.startsWith("name: Quarkiverse Prepare Release"))) {
                    // The file names are wrong here, we need to fix them
                    Path tmpFile = Files.createTempFile("tmp", ".yml");
                    Files.move(releasePrepare, tmpFile, StandardCopyOption.REPLACE_EXISTING);
                    Files.move(releasePerform, releasePrepare, StandardCopyOption.REPLACE_EXISTING);
                    Files.move(tmpFile, releasePerform, StandardCopyOption.REPLACE_EXISTING);
                }
            }
        } else {
//            Path preRelease = Path.of(".github/workflows/pre-release.yml");
//            Path release = Path.of(".github/workflows/release.yml");
//            if (Files.deleteIfExists(releaseWorkflow)) {
//                Files.copy(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jgit/.github/workflows/pre-release.yml"), preRelease, StandardCopyOption.REPLACE_EXISTING);
//                Files.copy(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jgit/.github/workflows/release-prepare.yml"), releasePrepare);
//                Files.copy(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jgit/.github/workflows/release-perform.yml"), releasePerform);
//            }
        }
    }
}
