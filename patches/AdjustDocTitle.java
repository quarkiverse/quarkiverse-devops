///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS org.yaml:snakeyaml:2.0

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.util.Collections;
import java.util.Map;

public class AdjustDocTitle {

    public static void main(String... args) throws Exception {
        File antoraFile = new File("docs/antora.yml");
        if (antoraFile.exists()) {
            final DumperOptions options = new DumperOptions();
            options.setIndent(3);
            options.setIndicatorIndent(2);
            options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
            Yaml yaml = new Yaml(options);
            Map<String, String> data = Collections.emptyMap();
            try (var is = new FileInputStream(antoraFile)) {
                data = yaml.load(is);
            }
            String title = data.get("title");
            if (title.startsWith("Quarkus ")) {
                data.put("title", title.substring("Quarkus ".length()).trim());
                try (var writer = new FileWriter(antoraFile)) {
                    yaml.dump(data, writer);
                }
            }
        }
    }
}
