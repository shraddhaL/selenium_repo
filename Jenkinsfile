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
	    stage('Clone repository') { /
			   steps {	       
				       * Clone repository */ checkout scm }
        
			   }
	    
	     stage('Build Jar') {
            steps {
		   	 sh'docker stop $(docker ps -q) || docker rm $(docker ps -a -q) || docker rmi $(docker images -q -f dangling=true)'
        		 sh 'docker system prune --all --volumes --force'
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
			     withCredentials([usernamePassword( credentialsId: '76599700-71c5-4af4-b805-1bcd97a088e4', usernameVariable: 'shraddhal', passwordVariable: 'dockerhub1234')]) {
					
			docker.withRegistry('https://registry.hub.docker.com', '76599700-71c5-4af4-b805-1bcd97a088e4') {
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
			//sh 'docker run -d -p 4444:4444 --memory="1.5g" --memory-swap="2g" -v /dev/shm:/dev/shm selenium/standalone-chrome'
			sh 'docker-compose up -d'
			//sh 'mvn test'
			
                }
            }
        }
	stage('Execute') {
		 steps {
                script {
		/* Execute the pytest script. On faliure proceed to next step */
        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
      
                sh 'docker run --network="host" --rm -v ${WORKSPACE}/allure-results:/AllureReports shraddhal/seleniumtest --executor "remote" --browser "chrome" .'
       
	}}}
  	 }
 
	    
	    
	 stage('Docker Teardown') {
    		/* Tear down docker compose */
		  steps {
                script {
           sh 'docker-compose down'
		}    }}
    
	    
	   stage('Create Report') {
		    steps {
                script {
        /* Generate Allure Report */
        allure includeProperties: false, jdk: '', results: [[path: 'allure-results']]
		}}}
  
	    
}
}
