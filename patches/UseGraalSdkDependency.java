///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS org.l2x6.pom-tuner:pom-tuner:4.2.0

import org.l2x6.pom.tuner.PomTransformer;
import org.l2x6.pom.tuner.model.Ga;
import org.w3c.dom.Document;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;

/**
 * Replaces {@code org.graalvm.nativeimage:svm} dependency with {@code org.graalvm.sdk:graal-sdk} in all {@code pom.xml}
 */
public class UseGraalSdkDependency {

    public static void main(String... args) throws IOException {
        // Traverse the directory looking for pom.xml files
        Files.walkFileTree(Path.of("."), new SimpleFileVisitor<>() {
            @Override
            public FileVisitResult visitFile(Path file, java.nio.file.attribute.BasicFileAttributes attrs) {
                if (file.getFileName().toString().equals("pom.xml")) {
                    replaceDependency(file);
                }
                return FileVisitResult.CONTINUE;
            }

            @Override
            public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
                return super.preVisitDirectory(dir, attrs);
            }
        });
    }

    public static void replaceDependency(Path pom) {
        Ga from = Ga.of("org.graalvm.nativeimage", "svm");
        Ga to = Ga.of("org.graalvm.sdk", "graal-sdk");

        new PomTransformer(pom, StandardCharsets.UTF_8, PomTransformer.SimpleElementWhitespace.AUTODETECT_PREFER_EMPTY).transform((Document document, PomTransformer.TransformationContext context) -> {
            context.getContainerElement("project", "dependencies").ifPresent((dependencies) -> {
                for (PomTransformer.ContainerElement dep : dependencies.childElements()) {
                    final Ga ga = dep.asGavtcs().toGa();
                    if (ga.equals(from)) {
                        dep.addOrSetChildTextElement("groupId", to.getGroupId());
                        dep.addOrSetChildTextElement("artifactId", to.getArtifactId());
                    }
                }
            });
        });
    }
}
