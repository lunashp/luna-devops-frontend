import axios from "axios";

const apiClient = axios.create({
    baseURL: 'http://34.64.84.30:8081',
    headers: {
        "Content-Type": "application/json",
    },
});

export default apiClient;
