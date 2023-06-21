///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS org.l2x6.pom-tuner:pom-tuner:4.2.0

import org.l2x6.pom.tuner.PomTransformer;
import org.w3c.dom.Document;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class AddScm {

    public static void main(String... args) {
        Path parent = Path.of("pom.xml");
        if (Files.exists(parent)) {
            String fullName = args[0];
            String connectionUrl = "scm:git:git@github.com:%s.git".formatted(fullName);
            String url = "https://github.com/%s".formatted(fullName);

            new PomTransformer(parent, StandardCharsets.UTF_8, PomTransformer.SimpleElementWhitespace.AUTODETECT_PREFER_EMPTY)
                    .transform((Document document, PomTransformer.TransformationContext context) -> {
                        if (context.getContainerElement("project", "scm").isEmpty()) {
                            final PomTransformer.ContainerElement scm = context.getOrAddContainerElement("scm");
                            scm.addOrSetChildTextElement("connection", connectionUrl);
                            scm.addOrSetChildTextElement("developerConnection", connectionUrl);
                            scm.addOrSetChildTextElement("url", url);
                        }
                    });


        }
    }
}
