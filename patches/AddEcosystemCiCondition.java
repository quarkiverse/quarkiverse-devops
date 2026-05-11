/// usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;

public class AddEcosystemCiCondition {

    public static void main(String... args) throws Exception {
        Path workflowFile = Path.of(".github/workflows/quarkus-snapshot.yaml");
        if (!Files.exists(workflowFile)) {
            System.out.println("No quarkus-snapshot.yaml found, skipping");
            return;
        }
        String content = Files.readString(workflowFile);
        if (content.contains("github.actor == 'quarkusbot'")) {
            System.out.println("Condition already present, skipping");
            return;
        }
        content = content.replace(
                "  build:\n    uses:",
                "  build:\n    if: github.event_name == 'workflow_dispatch' || github.actor == 'quarkusbot' || github.actor == 'quarkiversebot'\n    uses:");
        Files.writeString(workflowFile, content);
        System.out.println("Updated " + workflowFile);
    }
}
