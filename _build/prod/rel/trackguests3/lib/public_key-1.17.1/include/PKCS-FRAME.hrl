%% Generated by the Erlang ASN.1 compiler. Version: 5.3.4
%% Purpose: Erlang record definitions for each named and unnamed
%% SEQUENCE and SET, and macro definitions for each value
%% definition in module PKCS-FRAME.

-ifndef(_PKCS_FRAME_HRL_).
-define(_PKCS_FRAME_HRL_, true).

-record('AlgorithmIdentifierPKCS5v2-0', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('PKAttribute', {
  type,
  values,
  valuesWithContext = asn1_NOVALUE
}).

-record('PKAttribute_valuesWithContext_SETOF', {
  value,
  contextList
}).

-record('AlgorithmIdentifierPKCS-8', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('RC5-CBC-Parameters', {
  version,
  rounds,
  blockSizeInBits,
  iv = asn1_NOVALUE
}).

-record('RC2-CBC-Parameter', {
  rc2ParameterVersion = asn1_NOVALUE,
  iv
}).

-record('PBMAC1-params', {
  keyDerivationFunc,
  messageAuthScheme
}).

-record('PBMAC1-params_keyDerivationFunc', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('PBMAC1-params_messageAuthScheme', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('PBES2-params', {
  keyDerivationFunc,
  encryptionScheme
}).

-record('PBES2-params_keyDerivationFunc', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('PBES2-params_encryptionScheme', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('PBEParameter', {
  salt,
  iterationCount
}).

-record('PBKDF2-params', {
  salt,
  iterationCount,
  keyLength = asn1_NOVALUE,
  prf = asn1_DEFAULT
}).

-record('PBKDF2-params_salt_otherSource', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('PBKDF2-params_prf', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('Context', {
  contextType,
  contextValues,
  fallback = asn1_DEFAULT
}).

-record('EncryptedPrivateKeyInfo', {
  encryptionAlgorithm,
  encryptedData
}).

-record('EncryptedPrivateKeyInfo_encryptionAlgorithm', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('Attributes_SETOF', {
  type,
  values,
  valuesWithContext = asn1_NOVALUE
}).

-record('Attributes_SETOF_valuesWithContext_SETOF', {
  value,
  contextList
}).

-record('OneAsymmetricKey', {
  version,
  privateKeyAlgorithm,
  privateKey,
  attributes = asn1_NOVALUE,
  %% with extensions
  publicKey = asn1_NOVALUE
  %% end of extensions
}).

-record('OneAsymmetricKey_privateKeyAlgorithm', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-record('PrivateKeyInfo', {
  version,
  privateKeyAlgorithm,
  privateKey,
  attributes = asn1_NOVALUE
}).

-record('PrivateKeyInfo_privateKeyAlgorithm', {
  algorithm,
  parameters = asn1_NOVALUE
}).

-define('rc5-CBC-PAD', {1,2,840,113549,3,9}).
-define('rc2CBC', {1,2,840,113549,3,2}).
-define('des-EDE3-CBC', {1,2,840,113549,3,7}).
-define('desCBC', {1,3,14,3,2,7}).
-define('id-hmacWithSHA1', {1,2,840,113549,2,7}).
-define('encryptionAlgorithm', {1,2,840,113549,3}).
-define('digestAlgorithm', {1,2,840,113549,2}).
-define('id-PBMAC1', {1,2,840,113549,1,5,14}).
-define('id-PBES2', {1,2,840,113549,1,5,13}).
-define('pbeWithSHA1AndRC2-CBC', {1,2,840,113549,1,5,11}).
-define('pbeWithSHA1AndDES-CBC', {1,2,840,113549,1,5,10}).
-define('pbeWithMD5AndRC2-CBC', {1,2,840,113549,1,5,6}).
-define('pbeWithMD5AndDES-CBC', {1,2,840,113549,1,5,3}).
-define('pbeWithMD2AndRC2-CBC', {1,2,840,113549,1,5,4}).
-define('pbeWithMD2AndDES-CBC', {1,2,840,113549,1,5,1}).
-define('id-PBKDF2', {1,2,840,113549,1,5,12}).
-define('pkcs-5', {1,2,840,113549,1,5}).
-define('pkcs', {1,2,840,113549,1}).
-define('rsadsi', {1,2,840,113549}).
-endif. %% _PKCS_FRAME_HRL_
