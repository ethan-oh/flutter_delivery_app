// ignore_for_file: constant_identifier_names

import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const simulatorIp = '127.0.0.1:3000';
const emulatorIp = '10.0.0.2:3000';
final ip = Platform.isIOS ? simulatorIp : emulatorIp;
