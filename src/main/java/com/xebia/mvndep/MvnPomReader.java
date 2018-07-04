package com.xebia.mvndep;


import org.apache.maven.model.Dependency;
import org.apache.maven.model.building.*;

import java.io.File;
import java.util.List;

public class MvnPomReader {
    private final ModelBuildingResult result;

    public MvnPomReader(String pathToPomFile) {
        result = loadPom(pathToPomFile);
    }

    private ModelBuildingResult loadPom(String pathToPomFile) {
        ModelBuildingRequest req = new DefaultModelBuildingRequest()
                .setSystemProperties(System.getProperties())
                .setPomFile(new File(pathToPomFile))
                .setValidationLevel( ModelBuildingRequest.VALIDATION_LEVEL_MINIMAL );
        ModelBuilder builder = new DefaultModelBuilderFactory().newInstance();
        ModelBuildingResult result;
        try {
            result = builder.build(req);
        }
        catch (ModelBuildingException e) {
            String pomPath = req.getPomFile().getAbsolutePath();
            StringBuilder sb = new StringBuilder("Found ").append(e.getProblems().size())
                    .append(" problems while building POM model from ").append(pomPath).append("\n");
            int counter = 1;
            for (ModelProblem problem : e.getProblems()) {
                sb.append(counter++).append("/ ").append(problem).append("\n");
            }
            throw new RuntimeException(sb.toString());
        }
        return result;
    }

    public List<Dependency> getDependencies() {
        return result.getEffectiveModel().getDependencies();
    }
}
