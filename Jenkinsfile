#!groovy

pipeline {
	agent {
		dockerfile {
			filename "Dockerfile.build"
		}
	}

	triggers {
		pollSCM "@midnight"
	}

	environment {
		IMAGE = "protomouse/godot"
		BRANCH = "2.1"
		DOCKER_HUB = credentials("DockerHub")
	}

	stages {
		stage("Build") {
			steps {
				checkout scm
				dir("src") {
					git branch: "$BRANCH", url: "https://github.com/godotengine/godot.git"
				}
				sh "rm -rf target && /build.sh src target"
				sh "cp Dockerfile xorg.conf wrapper.sh target && docker build -t $IMAGE:$BRANCH target"
			}
		}

		stage("Deploy") {
			steps {
				sh "docker login -u $DOCKER_HUB_USR -p $DOCKER_HUB_PSW"
				sh "docker push $IMAGE:$BRANCH"
			}
		}
	}
}
