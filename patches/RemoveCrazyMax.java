///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.OptionalInt;
import java.util.stream.IntStream;

/**
 * Remove the crazy-max/ghaction-import-gpg action from the release.yml workflow and update actions
 */
public class RemoveCrazyMax {

    public static void main(String... args) throws Exception {
        Path workflowFile = Path.of(".github/workflows/release.yml");
        if (Files.exists(workflowFile)) {
            List<String> lines = Files.readAllLines(workflowFile);
            // Find the index of the line that ends with "Import GPG key"
            OptionalInt indexOpt = IntStream.range(0, lines.size())
                    .filter(i -> lines.get(i).endsWith("Import GPG key"))
                    .findFirst();
            if (indexOpt.isPresent()) {
                int index = indexOpt.getAsInt();
                int end = index;
                while (end != lines.size() && !lines.get(end).endsWith("passphrase: ${{ secrets.GPG_PASSPHRASE }}")) {
                    end++;
                }
                lines.subList(index, end + 2).clear();
            }
            indexOpt = IntStream.range(0, lines.size()).filter(i -> lines.get(i).endsWith("server-password: MAVEN_PASSWORD")).findFirst();
            if (indexOpt.isPresent()) {
                int index = indexOpt.getAsInt();
                lines.add(index + 1, "          gpg-private-key: ${{ secrets.GPG_PRIVATE_KEY }}");
                lines.add(index + 2, "          gpg-passphrase: MAVEN_GPG_PASSPHRASE");
            }
            indexOpt = IntStream.range(0, lines.size()).filter(i -> lines.get(i).endsWith("MAVEN_PASSWORD: ${{ secrets.OSSRH_TOKEN }}")).findFirst();
            if (indexOpt.isPresent()) {
                int index = indexOpt.getAsInt();
                lines.add(index + 1, "          MAVEN_GPG_PASSPHRASE: ${{ secrets.GPG_PASSPHRASE }}");
            }
            indexOpt = IntStream.range(0, lines.size()).filter(i -> lines.get(i).endsWith("- uses: actions/checkout@v3")).findFirst();
            if (indexOpt.isPresent()) {
                int index = indexOpt.getAsInt();
                lines.set(index, lines.get(index).replace("v3", "v4"));
            }
            Files.write(workflowFile, lines, StandardCharsets.UTF_8);
        }
    }

}
