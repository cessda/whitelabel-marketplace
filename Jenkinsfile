pipeline {
	environment {
		PRODUCT_NAME = 'marketplace'
		IMAGE_REPOSITORY = "${DOCKER_ARTIFACT_REGISTRY}/${PRODUCT_NAME}"
		IMAGE_TAG = "${IMAGE_REPOSITORY}:${env.BUILD_NUMBER}"
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
		stage('Deploy Marketplace') {
			steps {
				build job: 'cessda.marketplace.deploy/main', parameters: [
					string(name: 'MARKETPLACE_DOCKER_IMAGE', value: "${DOCKER_ARTIFACT_REGISTRY}/${PRODUCT_NAME}"),
					string(name: 'MARKETPLACE_IMAGE_TAG', value: env.BUILD_NUMBER)
				], wait: false
			}
			when { branch 'cessda-customisations' }
		}
	}
}
