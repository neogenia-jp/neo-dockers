<?php

/**
 * https://github.com/GitHub30/digital-address.php より流用
 */

$API_BASE_URL = 'https://api.da.pf.japanpost.jp/api/v1';  // 本番用APIアドレス
// $API_BASE_URL = 'https://stub-qz73x.da.pf.japanpost.jp/api/v1';  // テスト用APIアドレス
$API_KEY = $_ENV['X_API_KEY'];

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: *');
header('Access-Control-Allow-Headers: *');

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(204);
    exit;
}

// 特定のヘッダが付与されていない場合は403を返す
if (!isset($_SERVER['HTTP_X_API_KEY']) || $_SERVER['HTTP_X_API_KEY'] !== $API_KEY) {
    http_response_code(403);
    exit;
}

// 検索郵便番号の下処理
$search_code = $_GET['search_code'] ?? basename(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
$search_code = str_replace('-','', trim($search_code));   // ハイフンを削除する

// 郵便番号バリデーション
if (!preg_match('/^\d{3,7}$/', $search_code)) {
    http_response_code(400);
    exit;
}

// access_token.json は /tmp に保存させる
$token_filename = '/tmp/access_token.json';
if (file_exists($token_filename)) {
    $json = file_get_contents($token_filename);
    $obj = json_decode($json);
    if (time() < filemtime($token_filename) + $obj->expires_in) {
        $token = $obj->token;
    }
}

if (!isset($token)) {
    $ch = curl_init("$API_BASE_URL/j/token");
    curl_setopt($ch, CURLOPT_USERAGENT, 'curl/' . curl_version()['version']);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'x-forwarded-for: 127.0.0.1']);
    curl_setopt($ch, CURLOPT_POSTFIELDS, file_get_contents($_ENV['CREDENTIALS_FILE_PATH']));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $json = curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
    curl_close($ch);

    if ($code !== 200) {
        http_response_code($code);
        header('Content-Type: application/json');
        die($json);
    }

    file_put_contents($token_filename, $json);
    $token = json_decode($json)->token;
}

header('Content-Type: application/json');
$ch = curl_init("$API_BASE_URL/searchcode/$search_code");
curl_setopt($ch, CURLOPT_USERAGENT, 'curl/' . curl_version()['version']);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Authorization: Bearer $token"]);
curl_exec($ch);
http_response_code(curl_getinfo($ch, CURLINFO_RESPONSE_CODE));
curl_close($ch);