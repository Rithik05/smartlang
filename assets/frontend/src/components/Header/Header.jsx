import React, { useState } from "react";
import { FiUser } from "react-icons/fi"; // using react-icons for a nice user icon
import { useFetch } from "../../hooks/useFetch";
import { useEffect } from "react";
import { useNavigate } from "react-router-dom";

function Header() {
    const [dropdownOpen, setDropdownOpen] = useState(false);
    const [userEmail, setUserEmail] = useState("Loading");
    const navigate = useNavigate();
    const { makeRequest } = useFetch();

    const handleSignOut = () => {
        // Sign out logic here (like clearing tokens, redirecting, etc.)
        const SignOut = async () => {
            const result = await makeRequest({
                method: "POST",
                url: "http://localhost:4000/auth/logout",
            });

            if (result.status === 200 && result.data?.response == "Successfully signed out") {
                navigate("/")
            }
        };
        SignOut()
    };

    useEffect(() => {
        const UserInfo = async () => {
            const result = await makeRequest({
                method: "GET",
                url: "http://localhost:4000/userinfo",
            });
            if (result.status === 401) {
                navigate("/")
            }
            if (result.status === 200 && result.data?.response) {
                setUserEmail(result.data.response.email)
            }
        };
        UserInfo()
    }, [makeRequest, navigate]);

    return (
        <header className="w-full bg-gray-800 border-b border-gray-600 shadow-sm p-4 flex items-center justify-between">
            <div className="text-2xl font-semibold text-white tracking-tight">Smartlang-AI</div>

            <div className="relative">
                <button
                    onClick={() => setDropdownOpen(!dropdownOpen)}
                    className="p-2 rounded-full border bg-white border-gray-10000 hover:bg-gray-300 transition"
                >
                    <FiUser className="w-6 h-6 text-gray-700" />
                </button>

                {dropdownOpen && (
                    <div className="absolute right-0 mt-3 w-64 bg-white border border-gray-200 rounded-xl shadow-lg py-6 px-4 z-20">
                        <div className="flex flex-col items-center">
                            <div className="w-16 h-16 rounded-full bg-gray-200 flex items-center justify-center mb-4">
                                <FiUser className="w-8 h-8 text-gray-600" />
                            </div>
                            <div className="text-sm font-medium text-gray-800 mb-2">{userEmail}</div>
                            <button
                                onClick={handleSignOut}
                                className="w-full mt-2 text-sm text-white bg-red-500 hover:bg-red-600 rounded-lg py-2 transition"
                            >
                                Sign out
                            </button>
                        </div>
                    </div>
                )}
            </div>
        </header>
    );

}

export default Header;
