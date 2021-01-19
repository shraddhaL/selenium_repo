pipeline {
     agent any
	 tools {
        maven 'Maven' 
    }
	 environment {
        containerName = "shraddhal/seleniumtest"
        container_version = "1.0.0.${BUILD_ID}"
        dockerTag = "${containerName}:${container_version}"
    }
    stages { 	
        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Image') {
            steps {
                script {
                	app = docker.build("shraddhal/seleniumtest")
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
			     withCredentials([usernamePassword( credentialsId: 'fbdfdaaf-e9a6-4f7f-b3f3-c3ab0ce43636', usernameVariable: 'shraddhal', passwordVariable: 'dockerhub1234')]) {
					
			docker.withRegistry('https://registry.hub.docker.com', 'fbdfdaaf-e9a6-4f7f-b3f3-c3ab0ce43636') {
					sh "docker login -u shraddhal -p dockerhub1234"
					app.push("${BUILD_NUMBER}")
					app.push("latest")
				}
			
                }
            }
        }        
    }
	    
	       stage('compose') {
            steps {
                script {
                	sh ' docker-compose up'
                }
            }
        }
	    
}
}
