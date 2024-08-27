#!/bin/bash


# Step 1: Install the necessary npm packages

echo "Installing necessary npm packages..."

npm install @next/mdx @mdx-js/loader @mdx-js/react @types/mdx

npm install -D @tailwindcss/typography

npm install gray-matter next-mdx-remote

echo "Packages installed successfully."  
  

# Step 1-1: Replace `plugins: []` with `plugins: [require("@tailwindcss/typography")]` in tailwind.config.js

echo "Updating plugins in tailwind.config.js..."

sed -i.bak 's/plugins: \[\]/plugins: [require("@tailwindcss\/typography")]/' tailwind.config.js

rm tailwind.config.js.bak

  
  
  
  

# Step 2: Rename next.config.js to next.config.mjs

echo "Renaming next.config.js to next.config.mjs..."

mv next.config.js next.config.mjs

  

# Step 3: Replace content of next.config.mjs

echo "Updating content of next.config.mjs..."

cat > next.config.mjs << 'EOF'

import createMDX from "@next/mdx";

/** @type {import('next').NextConfig} */

const nextConfig = {

// Configure `pageExtensions` to include markdown and MDX files

pageExtensions: ["js", "jsx", "md", "mdx", "ts", "tsx"],

// Optionally, add any other Next.js config below

};

const withMDX = createMDX({

// Add markdown plugins here, as desired

});

// Merge MDX config with Next.js config

export default withMDX(nextConfig);

EOF

  

# Step 4: Create content directory and create sample blog post

echo "Creating content directory and sample blog post..."

mkdir -p content

cat > content/react-server-components.mdx << 'EOF'
---
title: "React Server Components"
description: "React Server Components"
date: "2024-07-07"
category: "React"
---


# React Server Components


React Server Components are a new way to build websites that work differently from traditional React components. They allow you to build websites that are faster, more secure, and easier to maintain.

## What are React Server Components?

React Server Components are a new type of React component that runs on the server instead of the client. This means that they can be used to build websites that are faster and more secure than traditional React components.

## How do React Server Components work?

React Server Components work by rendering the component on the server and sending the HTML to the client. This means that the client only needs to download the HTML, which is much faster than downloading the JavaScript code needed to render the component on the client.

## Why should I use React Server Components?

React Server Components are a great way to build websites that are faster, more secure, and easier to maintain. They allow you to build websites that are faster because they only need to download the HTML, which is much faster than downloading the JavaScript code needed to render the component on the client. They are also more secure because the JavaScript code is not sent to the client, which means that it is harder for hackers to exploit vulnerabilities in the code. Finally, they are easier to maintain because you can build websites that are more modular and easier to update.


```note
This post was written by Github Copilot. 
```


EOF

cat > content/do-not-gentile-into-that-good-night.mdx << 'EOF'
---
title: "Dylan Thomas : Do not go gentle into that good night"
description: "A poem by Dylan Thomas"
date: "2024-07-07"
category: "poetry"
---

# Do not go gentle into that good night : Dylan Thomas

Do not go gentle into that good night,
Old age should burn and rave at close of day;
Rage, rage against the dying of the light.

Though wise men at their end know dark is right,
Because their words had forked no lightning they
Do not go gentle into that good night.

Good men, the last wave by, crying how bright
Their frail deeds might have danced in a green bay,
Rage, rage against the dying of the light.

Wild men who caught and sang the sun in flight,
And learn, too late, they grieved it on its way,
Do not go gentle into that good night.

Grave men, near death, who see with blinding sight
Blind eyes could blaze like meteors and be gay,
Rage, rage against the dying of the light.

And you, my father, there on the sad height,
Curse, bless, me now with your fierce tears, I pray.
Do not go gentle into that good night.
Rage, rage against the dying of the light.[7]

EOF



  

# Step 5: Create components directory and mdx-layout.jsx file

echo "Creating components directory and mdx-layout.jsx file..."

mkdir -p components

cat > components/mdx-layout.jsx << 'EOF'

import "../app/globals.css";
export default function MdxLayout({ children }) {
  return (
    <div className="prose dark:prose-invert flex h-full flex-col items-center min-h-screen md:mx-auto md:py-24 py-6 mx-2">
      {children}
    </div>
  );
}

EOF

  

# Step 6: Create pages directory if it does not exist, and blog subdirectory

echo "Creating pages/blog directories..."

mkdir -p pages/blog

  

# Step 7: Create index.js file in blog subdirectory

echo "Creating index.js file in blog directory..."

cat > pages/blog/index.js << 'EOF'
import Link from "next/link";
import MdxLayout from "../../components/mdx-layout";
import fs from "fs";
import Head from "next/head";
import matter from "gray-matter";

const blogContentDirectory = "content";

export async function getStaticProps() {
  const files = fs.readdirSync(process.cwd() + "/" + blogContentDirectory);

  const posts = files.map((filename) => ({
    slug: filename.replace(".mdx", ""),

    title: filename.replace(".mdx", "").replace(/-/g, " "),

    date: matter(
      fs.readFileSync(blogContentDirectory + "/" + filename)
    ).data.date.toString(),

    category: matter(fs.readFileSync(blogContentDirectory + "/" + filename))
      .data.category,
  }));

  return {
    props: {
      posts,
    },
  };
}

export default function BlogIndex({ posts }) {
  return (
    <MdxLayout>
      <Head>
        <title>MDX Blog</title>
      </Head>
      <div className="flex flex-col items-start">
        <h1 className="mt-5 mb-10"> MDX Blog</h1>
        <p className="text-center">
          Blogs as MDX files in the <code>content</code> directory.
        </p>

        <div className="py-5 flex flex-col gap-y-1 justify-center">
          {posts.map((post) => (
            <Link
              href={`/blog/${post.slug}`}
              className="capitalize no-underline font-semibold"
              key={post.slug}
            >
              <div className="mb-2 flex flex-col">
                {post.title}
                <span className="text-sm text-gray-500 ">
                  {post.category ? `${post.category}` : ""}
                </span>
              </div>
            </Link>
          ))}
        </div>
        <Link href="/" className="mt-10 no-underline font-bold">
          ← Back to home
        </Link>
      </div>
    </MdxLayout>
  );
}

EOF

  

# Step 8: Create [slug] folder inside blog and index.js file inside it

echo "Creating [slug] directory and index.js file in it..."

mkdir -p pages/blog/[slug]

cat > pages/blog/[slug]/index.js << 'EOF'
import Link from "next/link";
import fs from "fs";
import path from "path";
import matter from "gray-matter";
import { serialize } from "next-mdx-remote/serialize";
import { MDXRemote } from "next-mdx-remote";
import Head from "next/head";

const blogContentDirectory = "content";
import MdxLayout from "../../../components/mdx-layout";

export default function BlogPost({ source, frontMatter }) {
  return (
    <div className="h-full">
      <MdxLayout>
        <Head>
          <title>{frontMatter.title}</title>

          <meta name="description" content={frontMatter.description} />
        </Head>

        <MDXRemote {...source} />
        <Link href="/blog" className="mt-10 no-underline font-bold">
          ← Back to blog
        </Link>
      </MdxLayout>
    </div>
  );
}

export async function getStaticPaths() {
  const files = fs.readdirSync(process.cwd() + "/" + blogContentDirectory);

  const paths = files.map((filename) => ({
    params: {
      slug: filename.replace(".mdx", ""),
    },
  }));

  return {
    paths,

    fallback: false,
  };
}

export async function getStaticProps({ params }) {
  const { slug } = params;

  const filePath = path.join(blogContentDirectory, `${slug}.mdx`);

  const fileContents = fs.readFileSync(filePath, "utf-8");

  const { content, data } = matter(fileContents);

  const mdxSource = await serialize(content);

  return {
    props: {
      source: mdxSource,

      frontMatter: data,
    },
  };
}

export async function generateMetaData(frontMatter) {
  return {
    title: frontMatter.title,

    description: frontMatter.description,
  };
}
EOF


echo "Modifying the global CSS file..."
# Step 9: Modify the global CSS file
# add the following content to the end of the file
STYLES='@layer components {
  .dark\:prose-invert {
    --tw-prose-body: var(--tw-prose-invert-body);
    --tw-prose-headings: var(--tw-prose-invert-headings);
    --tw-prose-links: var(--tw-prose-invert-links);
    --tw-prose-links-hover: var(--tw-prose-invert-links-hover);
    --tw-prose-underline: var(--tw-prose-invert-underline);
    --tw-prose-underline-hover: var(--tw-prose-invert-underline-hover);
    --tw-prose-bold: var(--tw-prose-invert-bold);
    --tw-prose-counters: var(--tw-prose-invert-counters);
    --tw-prose-bullets: var(--tw-prose-invert-bullets);
    --tw-prose-hr: var(--tw-prose-invert-hr);
    --tw-prose-quote-borders: var(--tw-prose-invert-quote-borders);
    --tw-prose-captions: var(--tw-prose-invert-captions);
    --tw-prose-code: var(--tw-prose-invert-code);
    --tw-prose-code-bg: var(--tw-prose-invert-code-bg);
    --tw-prose-pre-code: var(--tw-prose-invert-pre-code);
    --tw-prose-pre-bg: var(--tw-prose-invert-pre-bg);
    --tw-prose-pre-border: var(--tw-prose-invert-pre-border);
    --tw-prose-th-borders: var(--tw-prose-invert-th-borders);
    --tw-prose-td-borders: var(--tw-prose-invert-td-borders);
  }
}'

# File path for the globals.css
CSS_FILE="app/globals.css"

# Check if the file exists
if [ -f "$CSS_FILE" ]; then
  # Append the styles to the file
  echo "$STYLES" >> "$CSS_FILE"
  echo "Styles appended to $CSS_FILE successfully."
else
  echo "File $CSS_FILE does not exist."
fi


echo "Modifying the app/page.js file..."



PAGE_FILE="app/page.js"
# Check if the file exists
if [ ! -f "$PAGE_FILE" ]; then
  echo "File $PAGE_FILE does not exist."
  exit 1
fi


# Add the import statement if it doesn't exist
if ! grep -q "import Link from 'next/link';" "$PAGE_FILE"; then
  {
    echo "import Link from 'next/link';"
    cat "$PAGE_FILE"
  } > "${PAGE_FILE}.tmp" && mv "${PAGE_FILE}.tmp" "$PAGE_FILE"
  echo "Added import statement to $PAGE_FILE."
else
  echo "Import statement already exists in $PAGE_FILE."
fi

# Define the replacement text
NEW_DIV='<div className="fixed left-0 top-0 flex w-full justify-center border-b border-gray-300 bg-gradient-to-b from-zinc-200 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800\/30 dark:from-inherit lg:static lg:w-auto  lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800\/30">\
          <Link href="/blog" className="no-underline font-bold">\
            Blog\
          </Link>\
        </div>'

# Use awk to safely replace the specific <p> element with the <div> element
awk -v new_div="$NEW_DIV" '
BEGIN { pblock = 0 }
/<p className="fixed left-0 top-0 flex w-full justify-center border-b border-gray-300 bg-gradient-to-b from-zinc-200 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800\/30 dark:from-inherit lg:static lg:w-auto  lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800\/30">/ { pblock = 1; print new_div; next }
/<\/p>/ { if (pblock == 1) { pblock = 0; next } }
{ if (pblock == 0) print $0 }
' "$PAGE_FILE" > "${PAGE_FILE}.tmp" && mv "${PAGE_FILE}.tmp" "$PAGE_FILE"

echo "Blog created successfully! 🚀"