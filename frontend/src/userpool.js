import {CognitoUserPool} from 'amazon-cognito-identity-js';
const poolInfo = {
    UserPoolId: 'eu-west-2_Xk1XPDGP9',
    ClientId: 'r9qv3o66vcr7oj1575f61if71'
};

export default new CognitoUserPool(poolInfo)
