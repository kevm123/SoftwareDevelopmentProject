<?php
	
	 require_once __DIR__.'./daos/TaskDAO.class.php';
	 require_once __DIR__.'./daos/TagDAO.class.php';
	 require_once __DIR__.'./daos/UserDAO.class.php';
	 require_once __DIR__.'./utils/MySQLiAccess.class.php';
	
	
	session_start();
	require_once('load.php');
	
		$taskId = $_SESSION["TempTaskId"];
		$userId = $_SESSION["UserId"];
		
?>

<html>
<head>
		<meta name="viewport" content="initial-scale=1"><meta name="viewport" content="user-scalable=yes,width=device-width,initial-scale=1"><meta name="viewport" content="initial-scale=1"><meta name="viewport" content="user-scalable=yes,width=device-width,initial-scale=1"><title>GradeAce</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!--[if lte IE 8]><script src="assets/js/ie/html5shiv.js"></script><![endif]-->
		<link rel="stylesheet" href="assets/css/main.css">
		<!--[if lte IE 8]><link rel="stylesheet" href="assets/css/ie8.css" /><![endif]-->
		<!--[if lte IE 9]><link rel="stylesheet" href="assets/css/ie9.css" /><![endif]-->
	</head>
	<body class="">

		<!-- Nav -->
			<nav id="nav">
				<ul class="container">
					<li><a href="./index.php">Home</a></li>
					<li><a href=\"./logout.php\" class=\"\">Logout</a></li>
				</ul>
			</nav>

		<!-- Home -->
			<div class="wrapper style1 first">
				<article class="container" id="login">
					<div class="row">
						
						<div class="11u 12u(mobile)">
							<header>
							
								<?php
									//User chooses to assess the review of their task
									if(isset($_POST['assess_btn'])){
										
										
										$assessment = $_POST['assess'];
										$repNum = 0;
										$function = 0;
										
										//Sees if the user is 'happy' or 'unhappy' with their review
										if($assessment=="happy"){
											$function = 1;
										}else if($assessment=="unhappy"){
											$function = 2;
										}
										$userDAO = new UserDAO();
										$taskDAO = new TaskDAO();
										
										$reviewer = $taskDAO->getTaskClaimant($taskId);
										$reviewerId = $reviewer->getUserId();
										$reviewerRep = $reviewer->getReputation();
										
										$newReputation = 0;
										
										//Adds or takes 10 rep points from the reviewer depending on the users judgment of the review
										if ($function == 1){
											$newReputation= $reviewerRep + 10;
										}else if($function == 2){
											$newReputation = $reviewerRep - 10;
										}
										
										$result = $userDAO->updateReputation($reviewerId, $newReputation);
										
										if($result){
											echo "Assessment successful";
										}else{
											echo "ERROR - NOT SUCCESSFUL";
										}
										
										header("Location:./index.php");
										
										
									}
								
								
								
								
								?>
								
								
								
								<!-- Displays the claimants notes on the task -->
								<h1>Task Review Notes</h1>
								<h2>Below are the notes left be the Reviewer.<br>Please indicate if you are happy or not happy with these notes below before leaving</h2>
							</header>
							
							<?php
								$taskDAO = new TaskDAO();
								$task = $taskDAO->getTask($taskId);
								printf($task->getNotes());
							?>
							
							<form action="viewReview.php" method="post">
							
							<!-- 'Happy' and 'Unhappy' buttons for user -->
							<input type = "radio" value = "happy" name = "assess">Happy
							<input type = "radio" value = "unhappy" name = "assess">Unhappy</br>
							
							<input type="submit" value="Submit" name="assess_btn">
							</form>
							
						</div>
					</div>
				</article>
			</div>

		<!-- Work -->
			

		
			

		
			<div class="wrapper style4" id ="register">
				<article id="contact" class="container 75%">
					<footer>
						<ul id="copyright">
							<li>© GradeAce. All rights reserved.</li><li>Design: <a href="http://html5up.net">HTML5 UP</a></li>
						</ul>
					</footer>
				</article>
			</div>

		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/jquery.scrolly.min.js"></script>
			<script src="assets/js/skel.min.js"></script>
			<script src="assets/js/skel-viewport.min.js"></script>
			<script src="assets/js/util.js"></script>
			<!--[if lte IE 8]><script src="assets/js/ie/respond.min.js"></script><![endif]-->
			<script src="assets/js/main.js"></script>

	

</body>
</html>