import axios from "axios";

const apiClient = axios.create({
    baseURL: 'http://34.64.230.105:8081/api/posts',
    headers: {
        "Content-Type": "application/json",
    },
});

export default apiClient;
