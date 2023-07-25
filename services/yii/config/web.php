<?php

use yii\caching\FileCache;
use yii\log\FileTarget;
use yii\debug\Module;
use yii\gii\Module as giiModule;
use yii\symfonymailer\Mailer;

$params = require __DIR__ . '/params.php';
$db     = require __DIR__ . '/db.php';

$config = [
     'id'         => 'basic',
     'basePath'   => dirname(__DIR__),
     'bootstrap'  => ['log'],
     'aliases'    => [
          '@bower' => '@vendor/bower-asset',
          '@npm'   => '@vendor/npm-asset',
     ],
     'components' => [
          'request'      => [
              // !!! insert a secret key in the following (if it is empty) - this is required by cookie validation
              'cookieValidationKey' => '3aYrdFjN-aO7RE3k7s-p9QyxhtzuaIOx',
          ],
          'cache'        => [
               'class' => FileCache::class,
          ],
          'user'         => [
               'identityClass'   => 'app\models\User',
               'enableAutoLogin' => true,
          ],
          'errorHandler' => [
               'errorAction' => 'site/error',
          ],
          'mailer'       => [
               'class'            => Mailer::class,
               'viewPath'         => '@app/mail',
               // send all mails to a file by default.
               'useFileTransport' => true,
          ],
          'log'          => [
               'traceLevel' => YII_DEBUG ? 3 : 0,
               'targets'    => [
                    [
                         'class'  => FileTarget::class,
                         'levels' => ['error', 'warning'],
                    ],
               ],
          ],
          'db'           => $db,
          'urlManager'   => [
               'enablePrettyUrl' => true,
               'showScriptName'  => false,
               'rules'           => [
                    ''            => 'site/index', // Set the default route here
                    'hello-world' => 'site/hello-world', // Set the hello-world route here
                    //'<action:\w+>' => 'site/<action>', // This rule will handle other actions in the 'site' controller
               ],
          ],

     ],
     'params'     => $params,
];

if (YII_ENV_DEV) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][]      = 'debug';
    $config['modules']['debug'] = [
         'class' => Module::class,
         // uncomment the following to add your IP if you are not connecting from localhost.
         //'allowedIPs' => ['127.0.0.1', '::1'],
    ];

    $config['bootstrap'][]    = 'gii';
    $config['modules']['gii'] = [
         'class' => giiModule::class,
         // uncomment the following to add your IP if you are not connecting from localhost.
         //'allowedIPs' => ['127.0.0.1', '::1'],
    ];
}

return $config;
