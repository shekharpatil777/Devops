import com.bmuschko.docker.DockerClientFactory
import com.bmuschko.docker.DockerImage

def dockerClient = DockerClientFactory.instance.client

// Build the Docker Image
DockerImage image = dockerClient.imageBuilder()
    .from('openjdk:17-jdk-alpine')
    .file('src/main/java', './src/main/java')
    .file('src/main/resources', './src/main/resources')
    .build()

// Tag the Image
image.tag('your_username/your_image_name:latest')

// Push the Image to a Docker Registry
image.push('your_docker_registry_url')