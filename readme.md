# Create MDX Powered Blog in Next.js With One Script

![Mdx Blog Next.js](https://raw.githubusercontent.com/dbanswan/create-nextjs-blog-mdx/main/sample-images/1.png)

This script automates the process of setting up a mdx based blog section in a new Next.js site. It installs necessary packages, configures the project, and creates sample blog posts.

## Why make this script?

Anytime I have to setup a markdown based blog in next.js, it always results in lot of plubming work.

And whenever I do, it mostly results in the following steps:

- Forget how did I do it last time
- Explore alternatives (contentlayer great but abandoned), nothing catches the eye.
- Go to nextjs/mdx documentation
- Follow the steps
- Encounter lot of errors as this is a setup heavy process although not difficult.
- Finally get it working
- Forget how I did it this time
- Repeat

**Need to for automation was neigh.**

# Why only one script?

Anything more defeats the purpose, also a simple bash script is easy to understand and modify by anyone as per their needs.

## Prerequisites

- Node.js and npm installed
- A Next.js project set up
- You should have installed next.js like this, basically going with the defaults:

  ```sh
    npx create-next-app@latest mynextjs-site --use-npm                                                               ok
  ✔ Would you like to use TypeScript? … No
  ✔ Would you like to use ESLint? … Yes
  ✔ Would you like to use Tailwind CSS? …  Yes
  ✔ Would you like to use `src/` directory? … No
  ✔ Would you like to use App Router? (recommended) … Yes
  ✔ Would you like to customize the default import alias (@/*)? … No
  ```

## Reasoning for above choices

### This is a typical next.js setup for me because:

- Like javascript over typescript
- Always use tailwind css
- No need for src directory.
- I do use app router as it is recommended

If you have a different setup, you can always modify the script to suit your needs. It will be a simple process of changing may be js vs ts extension on files or changing the file paths.

### The styling is kept at a minimum, as that is a personal choice. Modify as per your needs.

## Steps Performed by the Script

1. **Install Necessary npm Packages**

   - Installs `@next/mdx`, `@mdx-js/loader`, `@mdx-js/react`, `@types/mdx`, `@tailwindcss/typography`, `gray-matter`, and `next-mdx-remote`.

2. **Update `tailwind.config.js`**

   - Replaces `plugins: []` with `plugins: [require("@tailwindcss/typography")]`.

3. **Rename `next.config.js` to `next.config.mjs`**

   - Renames the configuration file and updates its content to support MDX.

4. **Create Content Directory and Sample Blog Posts**

   - Creates a `content` directory and adds sample `.mdx` blog posts.

5. **Create Components Directory and `mdx-layout.jsx` File**

   - Creates a `components` directory and adds an MDX layout component.

6. **Create Blog Pages**

   - Creates `pages/blog` directory and adds `index.js` for listing blog posts.
   - Creates `pages/blog/[slug]` directory and adds `index.js` for individual blog posts.

7. **Modify Global CSS**

   - Appends custom styles to `app/globals.css`.

8. **Modify `app/page.js`**
   - Adds an import statement for `next/link` if it doesn't exist.
   - Replaces a specific `<p>` element with a `<div>` element containing a link to the blog.

## Usage

1. Place the `create-blog.sh` script in the root of your Next.js project.
2. Make the script executable:
   ```sh
   chmod +x create-blog.sh
   ```
3. Run the script:
   ```sh
    ./create-blog.sh
   ```
4. Start the development server:
   ```sh
   npm run dev
   ```
5. Visit `http://localhost:3000/blog` to see the sample blog posts.

## How do I create a new blog post?

1. Create a new `.mdx` file in the `content` directory.

2. Add the following front matter to the file and write your blog post content:

```mdx
---
title: "My New Blog Post"
description: "This is a sample blog post."
date: "2024-07-07"
category: "Personal"
---

# Sample Blog Post

Why did chicken cross the road?. I finally found the answer.
```

That's it! Your new blog post will be automatically added to the blog listing page. Please note slug is generated from the file name. So, saving the file as `my-new-blog-post.mdx` will generate a slug of `my-new-blog-post`.
