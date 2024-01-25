///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS org.l2x6.pom-tuner:pom-tuner:4.2.0

import org.l2x6.pom.tuner.PomTransformer;
import org.w3c.dom.Document;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class UpdateReleaseWorkflow {

    public static void main(String... args) throws Exception {

        // Delete the maven-settings.xml.gpg file
        Path path = Path.of(".github/release/maven-settings.xml.gpg");
        Files.deleteIfExists(path);
        // Update the release workflow
        Path releaseWorkflow = Path.of(".github/workflows/release.yml");
        if (Files.exists(releaseWorkflow)) {
            // TODO: use an URL
            Files.write(releaseWorkflow, Files.readAllBytes(Path.of("/Users/ggastald/workspace/quarkiverse/quarkus-jsch/.github/workflows/release.yml")));
        }
        // Make sure the copy-resources phase is correct
        Path docsPom = Path.of("docs/pom.xml");
        if (Files.exists(docsPom)) {
            new PomTransformer(docsPom, StandardCharsets.UTF_8, PomTransformer.SimpleElementWhitespace.AUTODETECT_PREFER_EMPTY).transform((Document document, PomTransformer.TransformationContext context) -> {
                context.getContainerElement("project", "build", "plugins").ifPresent((plugins) -> {
                    for (PomTransformer.ContainerElement plugin : plugins.childElements()) {
                        plugin.getChildContainerElement("artifactId").filter(f -> f.getNode().getTextContent().equals("maven-resources-plugin")).ifPresent((artifactId) -> {
                            // Iterate executions
                            plugin.getChildContainerElement("executions").ifPresent((executions) -> {
                                for (PomTransformer.ContainerElement execution : executions.childElements()) {
                                    execution.getChildContainerElement("id").filter(f -> f.getNode().getTextContent().equals("copy-resources")).ifPresent((id) -> {
                                        execution.addOrSetChildTextElement("phase", "generate-resources");
                                    });
                                }
                            });
                        });
                    }
                });
            });
        }
    }
}
