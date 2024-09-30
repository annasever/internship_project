import axios from '../helper/axios';

export const axiosCall = (url, method, data) => axios({ method, url, data });

//const apiBaseUrl = process.env.REACT_APP_API_BASE_URL || 'http://localhost:8080';

//const axiosInstance = axios.create({
//  baseURL: apiBaseUrl,
//});

//export default axiosInstance;

