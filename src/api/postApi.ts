import apiClient from "./apiClient";

export const getPosts = async () => {
    const response = await apiClient.get("/");
    return response.data;
};

export const getPostById = async (id: number) => {
    const response = await apiClient.get(`/${id}`);
    return response.data;
};

export const createPost = async (post: { title: string; content: string }) => {
    const response = await apiClient.post("/", post);
    return response.data;
};

export const updatePost = async (id: number, post: { title: string; content: string }) => {
    const response = await apiClient.put(`/${id}`, post);
    return response.data;
};

export const deletePost = async (id: number) => {
    await apiClient.delete(`/${id}`);
};
