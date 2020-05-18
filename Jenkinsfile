node {
 		String tag;
   try{
			  
			  containerStatus=	bat(returnStdout:true , script: "docker inspect -f '{{.Config.Image}}' spring-docker-compose")
			  println(containerStatus);
			  containerStatusResult = containerStatus.readLines().drop(2).join(" ") 
			  containerStatusResult = containerStatusResult.replaceAll("'", "");
			  String[] tagArray;
			  tagArray=containerStatusResult.split(':');
			  tag=tagArray[2].toString();				
				
		String inputTag=tag;
		String[] inputTagArray=inputTag.split('\\.');
		int majorVersion=Integer.parseInt(inputTagArray[0]);
		int minorVersion=Integer.parseInt(inputTagArray[1]);
		int patchVersion=Integer.parseInt(inputTagArray[2]);
		String patchVersionString,minorVersionString=null;
		for(int i=0;i<=9;i++) {
			if(patchVersion==i) {
				patchVersion++;
				break;
			}
		}
		if(patchVersion==10) {
		patchVersionString = String.valueOf(patchVersion);
		patchVersion=Integer.parseInt(Character.toString(patchVersionString.charAt(1)));
		println("patchVersion "+patchVersion);
		minorVersion++;
		if(minorVersion==10) {
			minorVersionString = String.valueOf(minorVersion);
			minorVersion=Integer.parseInt(Character.toString(minorVersionString.charAt(1)));
			println("minorVersion "+minorVersion);
			majorVersion++;
			println("majorVersion "+majorVersion);
			
			}
		}
		println("tag is created sucessfully  "+Integer.toString(majorVersion)+"."+Integer.toString(minorVersion)+"."+Integer.toString(patchVersion));
		tag=Integer.toString(majorVersion)+"."+Integer.toString(minorVersion)+"."+Integer.toString(patchVersion);
		script {
                    env.tag = tag
                }

			  
	  }
		 catch(err)
	  {
			println(err);
			tag="1.0.0"
			println("default tag   "+tag);
			script {
                    env.tag = tag
                }
			
	  }	 
	  
   stage('SCM Login  AND Checkout') {
      git credentialsId: 'c499039f-d083-49c0-ad02-8753e3f58f5b', poll: false, url: 'https://github.com/praveenkumar-network/spring-docker-compose.git/'
   }
   stage('Gradle Pacakge'){
   def gradleHome = tool name: 'maven', type: 'maven'
   def gradleCMD = "${gradleHome}//bin//mvn"
   bat "${gradleCMD}  clean install"
   }
    stage('Build Docker Image') {
      bat "docker build -t art.local:5001/spring-docker-compose:${tag} ."
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
	echo "Run Container with tag = ${env.tag}"
      bat "docker-compose up -d"
   }
  
 

}
