<?php
$query = "my=apples&are=green+and+red";

foreach (explode('&', $query) as $chunk) {
    $param = explode("=", $chunk);

    if ($param) {
        $_GET[urldecode($param[0])] = urldecode($param[1]);
    }
}

echo($_GET['my']."<br>".$_GET['are'].'<br>');


$res = openssl_pkey_new(array('private_key_bits' => 512));

/* Extract the private key from $res to $privKey */
openssl_pkey_export($res, $privKey);
/* Extract the public key from $res to $pubKey */
$pubKey = openssl_pkey_get_details($res);
$pubKey = $pubKey["key"];
$encrypted="";
$decrypted="";
openssl_public_encrypt($query, $encrypted, $pubKey);
$url_encoded_encrypted = urlencode($encrypted);
echo 'ENCRYPTED:'.$url_encoded_encrypted.'<br>';
$url_decoded_encrypted = urldecode($url_encoded_encrypted);
openssl_private_decrypt($url_decoded_encrypted,$decrypted,$privKey);
echo 'DECRYPTED:'.$decrypted.'<br>';

echo($pubKey);
echo('<br>');
echo($privKey);
?>