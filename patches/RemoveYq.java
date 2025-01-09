///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.OptionalInt;
import java.util.stream.IntStream;

/**
 * Remove the Install YQ step from the quarkus-snapshot.yaml workflow and update actions
 */
public class RemoveYq {

    public static void main(String... args) throws Exception {
        Path workflowFile = Path.of(".github/workflows/quarkus-snapshot.yaml");
        if (Files.exists(workflowFile)) {
            String fileContents = Files.readString(workflowFile, StandardCharsets.UTF_8);
            fileContents = fileContents.replace("""
      - name: Install yq
        run: sudo add-apt-repository ppa:rmescandon/yq && sudo apt update && sudo apt install yq -y

""", "");
            Files.writeString(workflowFile, fileContents);
        }
    }

}
