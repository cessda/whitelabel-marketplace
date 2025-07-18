pipeline {
	environment {
		PRODUCT_NAME = "marketplace"
		IMAGE_TAG = "${DOCKER_ARTIFACT_REGISTRY}/${productName}:${env.BUILD_NUMBER}"
	}

	agent {
		label 'jnlp-himem'
	}

	stages {
		stage('Build Docker Image') {
			steps {
				sh "docker build --tag=${IMAGE_TAG} ."
			}
		}
		stage('Push Docker Image') {
			steps {
				sh "gcloud auth configure-docker ${ARTIFACT_REGISTRY_HOST}"
				sh "docker push ${IMAGE_TAG}"
				sh "gcloud artifacts docker tags add ${IMAGE_TAG} ${DOCKER_ARTIFACT_REGISTRY}/${PRODUCT_NAME}:latest"
			}
			when { branch 'cessda-customisations' }
		}
	}
}
