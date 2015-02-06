<?php
require 'Slim/Slim.php';
\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim(array(
  'debug' => true
));

function echoResponse($status_code, $response) {
    $app = \Slim\Slim::getInstance();
    // Http response code
    $app->status($status_code);

    // setting response content type to json
    $app->contentType('application/json');

    echo $response;
}

$app->get('/:did', function($did) {
        $output = shell_exec('./statuscheck.sh ' .$did);
        echoResponse (200, $output);
});

$app->get('/all/', function() {
        $output = shell_exec('./statuscheck.sh all');
        echoResponse (200, $output);
});

$app->get('/all/:maxnum', function($maxnum) {
        $output = shell_exec('./statuscheck.sh all ' .$maxnum);
        echoResponse (200,  $output);
});

$app->post('/', function() use ($app) {
  $body = $app->request->getBody();
  $params = json_decode($body);

  if (array_key_exists("deviceid", $params)) {
    if (array_key_exists("status", $params) && array_key_exists("level",$params)) {
      $output1 = shell_exec('./changestate.sh ' .$params->deviceid .' ' .$params->status);
      $output2 = shell_exec('./changelevel.sh ' .$params->deviceid .' ' .$params->level);
      echoResponse (200, '{' .$output1 .',' .$output2 .'}');
    } else if (array_key_exists("status", $params)) {
      $output = shell_exec('./changestate.sh ' .$params->deviceid .' ' .$params->status);
      echoResponse (200, '{' .$output .'}');
    } else if (array_key_exists("level",$params)) {
      $output = shell_exec('./changelevel.sh ' .$params->deviceid .' ' .$params->level);
      echoResponse (200,  '{' .$output .'}');
    } else {
      echoResponse(200,  '{"Error":"Must include a status or level"}');
    }
  } else {
    echoResponse(200,  '{"Error":"Must include the deviceid"}');
  }

});

$app->get('/', function() use ($app) {
  echoResponse(200, '{"Error":"Must include the deviceid"}');
});

$app->run();

?>
