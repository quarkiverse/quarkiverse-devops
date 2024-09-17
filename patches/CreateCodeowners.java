///usr/bin/env jbang "$0" "$@" ; exit $?

import java.nio.file.Files;
import java.nio.file.Path;

public class CreateCodeowners {

    private static final String CONTENTS = """
            # Lines starting with '#' are comments.
            # Each line is a file pattern followed by one or more owners.
            
            # More details are here: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners
            
            # The '*' pattern is global owners.
            
            # Order is important. The last matching pattern has the most precedence.
            # The folders are ordered as follows:
            
            # In each subsection folders are ordered first by depth, then alphabetically.
            # This should make it easy to add new rules without breaking existing ones.
            
            *   @quarkiverse/quarkiverse-{extension.id}
            """;

    public static void main(String... args) throws Exception {
        // Update the release workflow
        Path file = Path.of(".github/CODEOWNERS");
        if (!Files.exists(file)) {
            String repo = args[0].replace("quarkiverse/quarkus-", "");
            Files.writeString(file, CONTENTS.replace("{extension.id}", repo));
        }
    }
}
