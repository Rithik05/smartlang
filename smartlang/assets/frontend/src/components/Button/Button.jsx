import React from "react";
import PropTypes from "prop-types";
import clsx from "clsx"; // if you want, or just string templates

export const Button = ({ children, className, disabled, ...props }) => {
  return (
    <button
      disabled={disabled}
      className={clsx(
        "inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-medium transition-colors",
        "bg-blue-600 text-white hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed",
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
};

Button.propTypes = {
  children: PropTypes.node.isRequired,
  className: PropTypes.string,
  disabled: PropTypes.bool,
};

Button.defaultProps = {
  className: "",
  disabled: false,
};
