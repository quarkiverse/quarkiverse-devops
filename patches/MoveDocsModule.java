///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS org.l2x6.pom-tuner:pom-tuner:4.3.0
//DEPS io.fabric8:maven-model-helper:37

import io.fabric8.maven.Maven;
import org.apache.maven.model.Activation;
import org.apache.maven.model.ActivationProperty;
import org.apache.maven.model.Model;
import org.apache.maven.model.Profile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * Move the <module>docs</module> to a Maven profile
 */
public class MoveDocsModule {

    public static void main(String... args) {
        Path parent = Path.of("pom.xml");
        if (Files.exists(parent)) {
            Model model = Maven.readModel(parent);
            List<String> modules = model.getModules();
            // Move the docs module to a profile
            if (modules.remove("docs")) {
                List<Profile> profiles = model.getProfiles();
                Profile docsProfile = new Profile();
                docsProfile.setId("docs");
                Activation activation = new Activation();
                ActivationProperty activationProperty = new ActivationProperty();
                activationProperty.setName("performRelease");
                activationProperty.setValue("!true");
                activation.setProperty(activationProperty);
                docsProfile.setActivation(activation);
                docsProfile.addModule("docs");
                // Add docs as the first profile
                profiles.add(0, docsProfile);
                Maven.writeModel(model);
            }
        }
    }
}
