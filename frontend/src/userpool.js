import {CognitoUserPool} from 'amazon-cognito-identity-js';
const poolInfo = {
    UserPoolId: 'eu-west-2_JJZA2kGWs',
    ClientId: '44ecsojarggv5c00140n1aj4do'
};

export default new CognitoUserPool(poolInfo)
