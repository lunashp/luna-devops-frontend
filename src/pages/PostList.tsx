import { useEffect, useState } from "react";
import { getPosts } from "../api/postApi";
import { Link } from "react-router-dom";

interface Post {
    id: number;
    title: string;
}

const PostList = () => {
    const [posts, setPosts] = useState<Post[]>([]);

    useEffect(() => {
        getPosts().then(setPosts).catch(console.error);
    }, []);

    return (
        <div>
            <h1>게시글 목록</h1>
            <Link to="/post/new">새 글 작성</Link>
            <ul>
                {posts.map((post) => (
                    <li key={post.id}>
                        <Link to={`/post/${post.id}`}>{post.title}</Link>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default PostList;
