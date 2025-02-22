import React, { useState, useEffect, useReducer } from 'react';
import 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const Home = ({userId}) => {
    const [listItem, setListItem] = useState('');
    const [bucketList, setBucketList] = useState([]);
    const [loading, setLoading] = useState(null);
    const [error, setError] = useState(null);
    const nav = useNavigate();
  
    
    useEffect(() => {
        const get_list = async () => {
            setLoading(true);
            try {
                const response = await axios.get(`http://127.0.0.1:5000/get_list/${userId}`);
                let data = response.data;
                if (data.length >= 1) {
                    setBucketList(data.map(item => ({ text: item.item, checked: item.checked })));}
                

            } catch (error) {
                console.error('Error fetching data:', error);
                setError(error.toString());
            } finally {
                setLoading(false);
            }
        };
        get_list();
    }, [userId]);
    
    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;
    
   

    const handleDelete = (index) => {
        const itemToDelete = bucketList[index];
        const updatedList = bucketList.filter((_, i) => i !== index);
        setBucketList(updatedList);
        let id = `${userId}${bucketList[index].text}`;
        axios.delete(`http://localhost:5000/delete_item/${id}`)
            .catch(error => {
                console.error('Error deleting item:', error);
                // Revert the change if the API call fails
                setBucketList(prevList => [...prevList.slice(0, index), itemToDelete, ...prevList.slice(index)]);
            });
    }

    const handleAdd = (e) => {
        e.preventDefault();
        if (listItem.trim() !== '') {
            setBucketList(prevList => [...prevList, { text: listItem, checked: false }]);
            setListItem('');
        }
    
        axios.post(`http://localhost:5000/add_item/${userId}`, {
            id: userId + listItem,
            item: listItem,
            checked: false,

        })
       
    }

    const handleCheckItem = (index) => {
        setBucketList(prevList => 
            prevList.map((item, i) => 
                i === index ? {...item, checked: !bucketList[i].checked } : item
            )
        );
        let id = `${userId}${bucketList[index].text}`;
        axios.put(`http://localhost:5000/update_item/${id}`,{
            checked: !bucketList[index].checked
         })
    }

    const logout = () => {
        nav('/login');
    }
        
    if (userId !== null){
        return (
            <section className="vh-100" style={{backgroundColor: "#e2d5de"}}>
                <div className="container py-5 h-100">
                    <div className="row d-flex justify-content-center align-items-center h-100">
                        <div className="col col-xl-10">
                            <div className="card" style={{borderRadius: "15px"}}>
                                <div className="card-body p-5">
                                    <h4 className="mb-3">Bucket List</h4>
                                    <form className="d-flex justify-content-center align-items-center mb-4" onSubmit={handleAdd}>
                                        <div className="form-outline flex-fill">
                                            <input 
                                                type="text" 
                                                id="form3" 
                                                className="form-control form-control-lg font-size-sm" 
                                                placeholder="to do"  
                                                value={listItem}
                                                onChange={(e) => setListItem(e.target.value)}
                                            />
                                        </div>
                                        <button type="submit" className="btn btn-primary btn-lg ms-2">Add</button>
                                    </form>
                                    <ul className="list-group mb-0" id="listFrame">
                                        {bucketList.map((item, index) => (
                                            <li key={index} className="list-group-item d-flex justify-content-between align-items-center border-start-0 border-top-0 border-end-0 border-bottom rounded-0 mb-2">
                                                <div className="d-flex align-items-center">
                                                    <input 
                                                        className="form-check-input me-2" 
                                                        type="checkbox" 
                                                        checked={item.checked}
                                                        onChange={() => handleCheckItem(index)} 
                                                    />
                                                    <span style={{ textDecoration: item.checked ? 'line-through' : 'none' }}>
                                                        {item.text}
                                                    </span>
                                                </div>
                                                <button className="btn btn-danger btn-xs" onClick={() => handleDelete(index)}> <i className="fas fa-trash fa-lg me-3 fa-fw justify-content-between align-items-center"></i></button>
                                            </li>
                                        ))}
                                    </ul>    
                                </div>
                                <button className="btn btn-primary btn-xs" onClick={logout}> <i className="fas fa-door-open fa-lg me-3 fa-fw justify-content-between align-items-right"></i></button>
                            </div>  
                        </div>
                    </div>
                </div>              
            </section>          
        )} else {
            nav('/login')
            return null
        }
    }

export default Home;
