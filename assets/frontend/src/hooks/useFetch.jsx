import { useState, useCallback } from "react";

export const useFetch = () => {
    const [response, setResponse] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    const makeRequest = useCallback(async ({ method, url, params = {}, headers = {} }) => {
        setLoading(true);
        setError(null);
        let csrfToken =
            document.querySelector("meta[name='csrf-token']")?.getAttribute("content") ||
            "";


        try {
            const options = {
                method,
                headers: {
                    "Content-Type": "application/json",
                    "x-csrf-token": csrfToken,
                    ...headers
                },
            };

            if (method !== "GET") {
                options.body = JSON.stringify(params);
            }

            const res = await fetch(url, options);
            const data = await res.json();
            setResponse(data);
            return { status: res.status, data };
        } catch (err) {
            setError(err);
            console.error("API call error:", err);
            return null;
        } finally {
            setLoading(false);
        }
    }, []);

    return { response, loading, error, makeRequest };
};
