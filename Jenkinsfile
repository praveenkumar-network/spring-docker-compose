node {
 		String buildTimeStamp="${BUILD_TIMESTAMP}"
		String[] buildTimeStampArray;
		buildTimeStampArray=buildTimeStamp.split(' ');
	  
		String dateString=buildTimeStampArray[0].toString();
		String[] dateArray;	
		dateArray=dateString.split('-'); 
		String dateResult=""; 
		for( String value : dateArray ){
		dateResult=dateResult+value;
		}			  
		String timeString=buildTimeStampArray[1].toString();
		String[] timeArray;	
		timeArray=timeString.split(':');  
		String timeResult=""; 
		for( String value : timeArray ){
		timeResult=timeResult+value;
		}
		String tag=dateResult+timeResult;
		 println(tag);
   stage('SCM Login  AND Checkout') {
      git credentialsId: 'c499039f-d083-49c0-ad02-8753e3f58f5b', poll: false, url: 'https://github.com/praveenkumar-network/spring-docker-compose.git/'
   }
   stage('Gradle Pacakge'){
   def gradleHome = tool name: 'maven', type: 'maven'
   def gradleCMD = "${gradleHome}//bin//mvn"
   bat "${gradleCMD}  clean install"
   }
    stage('Build Docker Image') {
      bat "docker build -t art.local:5001/spring-docker-compose ."
   }
   stage('Login Artifactory And Push Image') {
	withCredentials([string(credentialsId: 'artifactory-pwd', variable: 'artifactoryPwd')]) {
	 bat "docker login http://art.local:5001/artifactory -u admin -p ${artifactoryPwd}"
	 bat "docker push art.local:5001/spring-docker-compose"
	} 
   }
   stage('Stop Runing Container') {
	  try{
			  
			  containerStatus=	bat(returnStdout:true , script: "docker inspect -f '{{.State.Running}}' spring-docker-compose")
			  containerStatusResult = containerStatus.readLines().drop(2).join(" ") 
			  containerStatusResult = containerStatusResult.replaceAll("'", "");
			  if(containerStatusResult)
			  {
					bat 'docker stop spring-docker-compose'
			  }
	  }
	  catch(err)
	  {
			println(err);
	  }
	   
   }
   stage('Remove Stoped Container') {
   
		try{
				containerStatus=	bat(returnStdout:true , script: "docker inspect -f '{{.State.Running}}' spring-docker-compose")
				containerStatusResult = containerStatus.readLines().drop(2).join(" ") 
				containerStatusResult = containerStatusResult.replaceAll("'", "");
				if(containerStatusResult)
				{
				  bat 'docker rm spring-docker-compose'
				}else{
				
					}
			}
			catch(err)
			{
				println(err);
			}
   }
   stage('Deloy image and Run Container') {
      bat "docker-compose up -d"
   }
}
