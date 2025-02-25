import homeImage from './assets/home.jpg';
import React, {useState} from 'react';
import {
    AuthenticationDetails, CognitoUser
} from 'amazon-cognito-identity-js';
//import { CognitoUser } from "amazon-cognito-identity-js/enhance-rn.js"

import userPool from './userpool.js';
import { useNavigate } from 'react-router-dom';

const Login = ({onLogin}) => {
    const [credentials, setCredentials] = useState({
        email: '',
        password: '',
    });
    
    const nav = useNavigate();

    const handleChange = (e) => setCredentials({...credentials, [e.target.id]: e.target.value});

    const handleLogin = (e) => {
        e.preventDefault();
        console.log("handle login");
        const {email, password} = credentials;
        const authenticationDetails = new AuthenticationDetails({
            Email: email,
            Password: password,
        });
        const userData = { Username: email, Pool: userPool};
        const cognitoUser = new CognitoUser(userData);

        cognitoUser.authenticateUser(authenticationDetails, {
            onSuccess: (result) => {
                console.log('Login successful.');
               // props.userId = result.getIdToken().payload.sub;
                onLogin(result.getIdToken().payload.sub);
                console.log('Access tocken:', result.getRefreshToken().getToken());
                nav('/');
            },

            onFailure: (err) => {
                console.error('Error logging in:', err);
            },
        });
    };

    return(
          <>
            <section className="vh-100">
                <div className="container-fluid h-custom">
                    <div className="row d-flex justify-content-center align-items-center h-100">
                        <div className="col-md-9 col-lg-6 col-xl-5">
                            <img src={homeImage} className="img-fluid" alt="Sample" />
                        </div>


                        <div className="col-md-8 col-lg-6 col-xl-4 offset-xl-1">
                            <p className="text-center h1 fw-bold mb-5 mx-1 mx-md-4 mt-4">Login</p>
                            <form>
                                <div className="d-flex flex-row align-items-center mb-4">
                                    <i className="fas fa-envelope fa-lg me-3 fa-fw"></i>
                                    <div className="form-outline flex-fill mb-0">
                                        <input type="email" id="email" className="form-control" placeholder="Your Email" onChange={handleChange}/>
                                    </div>
                                </div>

                                <div className="d-flex flex-row align-items-center mb-4">
                                    <i className="fas fa-lock fa-lg me-3 fa-fw"></i>
                                    <div className="form-outline flex-fill mb-0">
                                        <input type="password" id="password" className="form-control" placeholder="Password" onChange={handleChange}/>
                                    </div>
                                </div>
      
                                <div className="d-flex justify-content-between align-items-center">
                             
                                    <div className="form-check mb-0">
                                    </div>
                                </div>




      
                                <div className="text-center text-lg-start mt-4 pt-2 ">
                                    <div className="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                                            <button
                                                type="button"
                                                className="btn btn-primary btn-lg"
                                                onClick={handleLogin}
                                            >
                                                Login
                                            </button>   
                                    </div>
                                    <div className="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                                            <p className="small fw-bold mt-2 pt-1 mb-0">Don't have an account? 
                                            <a href="/register" className="link-danger">Register</a>
                                            </p>
                                        
                                    </div>
                                    
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div className="d-flex flex-column flex-md-row justify-content-between fixed-bottom py-4 px-4 px-xl-5 bg-primary ">
                </div>
            </section>
         </>
        );
};

export default Login