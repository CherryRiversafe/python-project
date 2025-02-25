import React, {useState} from 'react';
import {CognitoUserAttribute, CognitoUser} from 'amazon-cognito-identity-js';
//import { CognitoUser } from "amazon-cognito-identity-js/enhance-rn.js";
import userPool from './userpool.js';
import { useNavigate } from 'react-router-dom';

  

const Register = () => {

  const [formState, setFormState] = useState({
    password: '',
    email: '',
    authCode: '',
    stage: 'regist',
  });

  const nav = useNavigate();

  const [checked, setChecked] = useState(false);

  const handleChange = (e) => {
   setFormState({...formState, [e.target.id]: e.target.value});
  };


  const submitForm = (e) => {
    e.preventDefault();
    const {password, email} = formState;
    const attributeList = [];
    const userEmailData = {Name:'email', Value:email};
    const userEmailAttribute = new CognitoUserAttribute(userEmailData);
    attributeList.push(userEmailAttribute);

    if (checked === false){ 
      console.error('Please agree with terms!');
      return;
    } 
      
    userPool.signUp(email, password, attributeList, null,(err, result) =>{
      if (err){
      console.error('Error occurred:', err);
      return;
      }
      console.log('Successfully regist with us!', result);
      setFormState({...formState, stage: 'confirm'});
    });
  };
      

  const confirmRegister = (e) => {
    e.preventDefault();
    const { email, authCode } = formState;
    const userData = { Username: email, Pool: userPool };
    const congnitoUser = new CognitoUser(userData);
    congnitoUser.confirmRegistration(authCode, true, (err, result) => {
      if (err) {
        console.error('Fail to confirm register:' , err);
        return;
      }
      console.log('Confirmation result:', result);
      nav('/login')
    }) ;
  };
    const confirmPasswd = (e) => {
      if (e.target.value !== formState.password){
        console.error('Passwords are not the same!');
        return;
      }
      console.log('Repeated password.');
    };

  const confirmTerm = () => {
    setChecked(!checked);
  }

  return (
    <div>
      {formState.stage === 'regist' ? (
        <section className="vh-100" style={{ backgroundColor: "#eee" }}>
          <div className="container h-100">
            <div className="row d-flex justify-content-center align-items-center h-100">
              <div className="col-lg-12 col-xl-11">
                <div className="card text-black" style={{ borderRadius: "25px" }}>
                  <div className="card-body p-md-5">
                    <div className="row justify-content-center">
                      {/* Left Column */}
                      <div className="col-md-10 col-lg-6 col-xl-5 order-2 order-lg-1">
                        <p className="text-center h1 fw-bold mb-5 mx-1 mx-md-4 mt-4">Sign up</p>
  
                        <form className="mx-1 mx-md-4" onSubmit={submitForm}>
  
                          {/* Email Input */}
                          <div className="d-flex flex-row align-items-center mb-4">
                            <i className="fas fa-envelope fa-lg me-3 fa-fw"></i>
                            <div className="form-outline flex-fill mb-0">
                              <input type="email" id="email" className="form-control" placeholder="Your Email" onChange={handleChange}/>
                            </div>
                          </div>
  
                          {/* Password Input */}
                          <div className="d-flex flex-row align-items-center mb-4">
                            <i className="fas fa-lock fa-lg me-3 fa-fw"></i>
                            <div className="form-outline flex-fill mb-0">
                              <input type="password" id="password" className="form-control" placeholder="Password" onChange={handleChange}/>
                            </div>
                          </div>
  
                          {/* Repeat Password Input */}
                          <div className="d-flex flex-row align-items-center mb-4">
                            <i className="fas fa-key fa-lg me-3 fa-fw"></i>
                            <div className="form-outline flex-fill mb-0">
                              <input type="password" id="repeatpassword" className="form-control" placeholder="Repeat your password" onChange={confirmPasswd}/>
                            </div>
                          </div>
  
                          {/* Terms Checkbox */}
                          <div className="form-check d-flex justify-content-center mb-5">
                            <div>
                                <input className="form-check-input me-2"
                                type="checkbox"
                                value=""
                                id="form2Example3c"
                                onChange = {confirmTerm}
                                />
                            </div>

                            <div>        
                                <label className="form-check-label" htmlFor="form2Example3c">
                                    <div>I agree to all statements in{" "}
                                    <a href="#!">Terms of service</a></div>
                                </label>
                            </div>
                          </div>
  
                          {/* Register Button */}
                          <div className="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                            <button
                              type="submit"
                              className="btn btn-primary btn-lg"
                            >
                              Register
                            </button>
                          </div>
                        </form>
                      </div>
  
                      {/* Right Column - Image */}
                      <div className="col-md-10 col-lg-6 col-xl-7 d-flex align-items-center order-1 order-lg-2">
                        <img
                          src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-registration/draw1.webp"
                          className="img-fluid"
                          alt="Sample image"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>) : (
          <form className="mx-1 mx-md-4" onSubmit={confirmRegister}>
          {/* AuthCode Input */}
            <div className="d-flex flex-row align-items-center mb-4">
              <div className="form-outline flex-fill mb-0">
                <input name='authCode' id="authCode" className="form-control" placeholder="Confirmation Code" onChange={handleChange} />
                <button type="submit" className="btn btn-primary btn-lg"> Confirm Register </button>    
              </div>
            </div>
          </form>

        )}
    </div>
  );
};
  
export default Register;
   