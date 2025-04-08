import { useEffect, useState } from "react";
import { useParams, useNavigate, Link } from "react-router-dom";
import { getPostById, deletePost } from "../api/postApi";

interface Post {
    id: number;
    title: string;
    content: string;
}

const PostDetail = () => {
    const { id } = useParams<{ id: string }>();
    const navigate = useNavigate();
    const [post, setPost] = useState<Post | null>(null);

    useEffect(() => {
        if (id) {
            getPostById(Number(id)).then(setPost).catch(console.error);
        }
    }, [id]);

    const handleDelete = async () => {
        if (id) {
            await deletePost(Number(id));
            navigate("/");
        }
    };

    if (!post) return <p>게시글을 불러오는 중...</p>;

    return (
        <div>
            <h1>{post.title}</h1>
            <p>{post.content}</p>
            <Link to={`/post/edit/${post.id}`}>수정</Link>
            <button onClick={handleDelete}>삭제</button>
        </div>
    );
};

export default PostDetail;
