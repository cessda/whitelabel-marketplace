pipeline {
	environment {
		productName = "marketplace"
		imageTag = "${DOCKER_ARTIFACT_REGISTRY}/${productName}:${env.BUILD_NUMBER}"
	}

	agent {
		label 'jnlp-himem'
	}

	stages {
		stage('Build Docker Image') {
			steps {
				sh "docker build --tag=${imageTag} ."
			}
		}
		stage('Push Docker Image') {
			steps {
				sh "gcloud auth configure-docker ${ARTIFACT_REGISTRY_HOST}"
				sh "docker push ${IMAGE_TAG}"
				sh "gcloud artifacts docker tags add ${IMAGE_TAG} ${DOCKER_ARTIFACT_REGISTRY}/${productName}:latest"
			}
			when { branch 'cessda-customisations' }
		}
	}
}
