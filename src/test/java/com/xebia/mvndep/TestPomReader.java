package com.xebia.mvndep;

import org.apache.maven.model.Dependency;
import org.junit.Assert;
import org.junit.Test;

import java.util.List;

public class TestPomReader {

    @Test
    public void testDependenciesContainDropwizard() {
        MvnPomReader mvnPomReader = new MvnPomReader("pom.xml");
        List<Dependency> dependencies = mvnPomReader.getDependencies();
        Assert.assertEquals(3, dependencies.size());
    }

}
