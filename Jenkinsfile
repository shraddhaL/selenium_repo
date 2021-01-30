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
	    stage('Clone repository') {
			   steps {	       
				 checkout scm }
        
			   }
	    
	     stage('Build Jar') {
            steps {////
		   	//sh'docker stop $(docker ps -q) || docker rm $(docker ps -a -q) || docker rmi $(docker images -q -f dangling=true)'
        		//sh 'docker system prune --all --volumes --force'
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
                script {// aws:76599700-71c5-4af4-b805-1bcd97a088e4
			     withCredentials([usernamePassword( credentialsId: '7d1e9b8f-6abf-4529-a30c-99f9173c2f2f', usernameVariable: 'shraddhal', passwordVariable: '')]) {
					
			docker.withRegistry('https://registry.hub.docker.com', '7d1e9b8f-6abf-4529-a30c-99f9173c2f2f') {
					sh "docker login -u shraddhal -p password"
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
      sh 'mvn test'
              sh 'docker run --network="host" --rm -v ${WORKSPACE}/allure-results:/AllureReports shraddhal/seleniumtest  --browser "chrome" .'
       
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
post {
          always {
            script {
              allure([
                includeProperties: false,
                jdk: '',
                properties: [],
                reportBuildPolicy: 'ALWAYS',
                results: [[path: 'target/allure-results']]
              ])
            }
          }
        }	
}
