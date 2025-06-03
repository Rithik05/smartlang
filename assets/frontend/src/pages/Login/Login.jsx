import React from "react";
import googlelogo from "../../assets/g_logo.png"

function Login() {
  const handleGoogleLogin = () => {
    window.location.href = "http://localhost:4000/auth/google";
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100 px-4">
      <div className="w-full max-w-md bg-white p-8 rounded-2xl shadow-lg text-center">
        <h2 className="text-2xl font-semibold text-gray-800 mb-6">
          Welcome Back 👋
        </h2>
        <p className="text-gray-500 mb-8">
          Sign in to continue using the app
        </p>

        <button
          onClick={handleGoogleLogin}
          className="w-full flex items-center justify-center gap-3 p-3 rounded-md border border-gray-300 hover:shadow-md transition duration-200"
        >
          <img
            src={googlelogo}
            alt="Google logo"
            className="w-5 h-5"
          />
          <span className="text-sm font-medium text-gray-700">
            Sign in with Google
          </span>
        </button>
      </div>
    </div>
  );
}

export default Login;
