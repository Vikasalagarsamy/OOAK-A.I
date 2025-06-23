--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Homebrew)
-- Dumped by pg_dump version 15.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO vikasalagarsamy;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: vikasalagarsamy
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounting_workflows; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.accounting_workflows (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instruction_id integer,
    status character varying(30) DEFAULT 'pending_processing'::character varying,
    total_amount numeric NOT NULL,
    payment_type character varying(20) NOT NULL,
    processed_by character varying(255),
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.accounting_workflows OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.accounting_workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounting_workflows_id_seq OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.accounting_workflows_id_seq OWNED BY public.accounting_workflows.id;


--
-- Name: action_recommendations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.action_recommendations (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    recommendation_type text NOT NULL,
    priority text NOT NULL,
    confidence_score numeric NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    suggested_action text NOT NULL,
    expected_impact jsonb DEFAULT '{}'::jsonb NOT NULL,
    reasoning text NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone
);


ALTER TABLE public.action_recommendations OWNER TO vikasalagarsamy;

--
-- Name: action_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.action_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_recommendations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: action_recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.action_recommendations_id_seq OWNED BY public.action_recommendations.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action_type character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id text NOT NULL,
    entity_name character varying(255) NOT NULL,
    description text NOT NULL,
    user_id uuid,
    user_name character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.activities OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_behavior_settings (
    id integer NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value jsonb NOT NULL,
    description text,
    category character varying(50) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_behavior_settings OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_behavior_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_behavior_settings_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_behavior_settings_id_seq OWNED BY public.ai_behavior_settings.id;


--
-- Name: ai_communication_tasks; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_communication_tasks (
    id integer NOT NULL,
    quotation_id integer,
    conversation_session_id integer,
    task_type character varying(50) NOT NULL,
    title text NOT NULL,
    description text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    assigned_to_employee_id integer,
    due_date timestamp without time zone,
    status character varying(20) DEFAULT 'pending'::character varying,
    ai_reasoning text,
    trigger_message_id integer,
    created_by_ai boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.ai_communication_tasks OWNER TO vikasalagarsamy;

--
-- Name: ai_communication_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_communication_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_communication_tasks_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_communication_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_communication_tasks_id_seq OWNED BY public.ai_communication_tasks.id;


--
-- Name: ai_configurations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_configurations (
    id integer NOT NULL,
    config_key character varying(100) NOT NULL,
    config_type character varying(50) NOT NULL,
    config_value text NOT NULL,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.ai_configurations OWNER TO vikasalagarsamy;

--
-- Name: ai_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_configurations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_configurations_id_seq OWNED BY public.ai_configurations.id;


--
-- Name: ai_contacts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone text,
    country_code text,
    name text,
    source_id text,
    source_url text,
    internal_lead_source text,
    internal_closure_date timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.ai_contacts OWNER TO vikasalagarsamy;

--
-- Name: ai_decision_log; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_decision_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id text,
    decision_type text NOT NULL,
    decision_data jsonb NOT NULL,
    model_version text DEFAULT 'v1.0'::text,
    confidence_score numeric,
    execution_time integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_decision_log OWNER TO vikasalagarsamy;

--
-- Name: ai_performance_tracking; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_performance_tracking (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    model_type text NOT NULL,
    prediction_data jsonb NOT NULL,
    actual_outcome jsonb,
    accuracy_score numeric,
    confidence_score numeric,
    model_version text DEFAULT 'v1.0'::text,
    feedback_loop_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_performance_tracking OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_prompt_templates (
    id integer NOT NULL,
    template_name character varying(100) NOT NULL,
    template_content text NOT NULL,
    variables jsonb DEFAULT '{}'::jsonb,
    category character varying(50) NOT NULL,
    is_default boolean DEFAULT false,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_prompt_templates OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_prompt_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_prompt_templates_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_prompt_templates_id_seq OWNED BY public.ai_prompt_templates.id;


--
-- Name: ai_recommendations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_recommendations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    recommendation_type text NOT NULL,
    recommendation_data jsonb NOT NULL,
    confidence_score numeric NOT NULL,
    context_data jsonb DEFAULT '{}'::jsonb,
    applied boolean DEFAULT false,
    feedback_score integer,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_recommendations OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_tasks (
    id integer NOT NULL,
    task_title character varying(255) NOT NULL,
    task_description text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    status character varying(20) DEFAULT 'pending'::character varying,
    due_date timestamp with time zone,
    category character varying(50),
    assigned_to character varying(255),
    assigned_by character varying(255),
    metadata jsonb,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    client_name character varying(255),
    business_impact text,
    ai_reasoning text,
    estimated_value numeric,
    lead_id integer,
    quotation_id integer,
    actual_hours numeric,
    quality_rating integer,
    assigned_to_employee_id integer,
    task_type character varying(50),
    completion_notes text,
    employee_id integer
);


ALTER TABLE public.ai_tasks OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_tasks_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_tasks_id_seq OWNED BY public.ai_tasks.id;


--
-- Name: analytics_cache; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.analytics_cache (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cache_key text NOT NULL,
    cache_data jsonb NOT NULL,
    cache_type text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.analytics_cache OWNER TO vikasalagarsamy;

--
-- Name: analytics_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.analytics_metrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    metric_name text NOT NULL,
    metric_type text NOT NULL,
    metric_value numeric NOT NULL,
    metric_unit text DEFAULT 'count'::text,
    dimensions jsonb DEFAULT '{}'::jsonb,
    time_period text NOT NULL,
    recorded_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.analytics_metrics OWNER TO vikasalagarsamy;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.branches (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    address text NOT NULL,
    phone character varying(50),
    email character varying(255),
    manager_id integer,
    is_remote boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    branch_code character varying(30),
    location character varying(255)
);


ALTER TABLE public.branches OWNER TO vikasalagarsamy;

--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.branches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branches_id_seq OWNER TO vikasalagarsamy;

--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;


--
-- Name: bug_attachments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bug_attachments (
    id bigint NOT NULL,
    bug_id bigint,
    file_name text NOT NULL,
    file_path text NOT NULL,
    file_type text NOT NULL,
    file_size integer NOT NULL,
    uploaded_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bug_attachments OWNER TO vikasalagarsamy;

--
-- Name: bug_comments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bug_comments (
    id bigint NOT NULL,
    bug_id bigint,
    user_id uuid NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bug_comments OWNER TO vikasalagarsamy;

--
-- Name: bugs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bugs (
    id bigint NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    severity text NOT NULL,
    status text DEFAULT 'open'::text NOT NULL,
    assignee_id uuid,
    reporter_id uuid NOT NULL,
    due_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bugs OWNER TO vikasalagarsamy;

--
-- Name: business_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.business_rules (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    department text NOT NULL,
    task_type text NOT NULL,
    priority text NOT NULL,
    due_after_hours integer DEFAULT 24 NOT NULL,
    due_after_days integer DEFAULT 1 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid
);


ALTER TABLE public.business_rules OWNER TO vikasalagarsamy;

--
-- Name: business_trends; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.business_trends (
    id integer NOT NULL,
    trend_type text NOT NULL,
    trend_period text NOT NULL,
    trend_direction text NOT NULL,
    trend_strength numeric NOT NULL,
    current_value numeric NOT NULL,
    previous_value numeric NOT NULL,
    percentage_change numeric NOT NULL,
    statistical_significance numeric NOT NULL,
    insights jsonb DEFAULT '{}'::jsonb NOT NULL,
    recommendations jsonb DEFAULT '{}'::jsonb NOT NULL,
    analyzed_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.business_trends OWNER TO vikasalagarsamy;

--
-- Name: business_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.business_trends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_trends_id_seq OWNER TO vikasalagarsamy;

--
-- Name: business_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.business_trends_id_seq OWNED BY public.business_trends.id;


--
-- Name: call_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    overall_sentiment character varying(20),
    sentiment_score numeric DEFAULT 0,
    client_sentiment character varying(20),
    agent_sentiment character varying(20),
    call_intent character varying(255),
    key_topics jsonb DEFAULT '[]'::jsonb,
    business_outcomes jsonb DEFAULT '[]'::jsonb,
    action_items jsonb DEFAULT '[]'::jsonb,
    agent_professionalism_score integer,
    agent_responsiveness_score integer,
    agent_knowledge_score integer,
    agent_closing_effectiveness integer,
    client_engagement_level character varying(20),
    client_interest_level character varying(20),
    client_objection_handling jsonb DEFAULT '[]'::jsonb,
    client_buying_signals jsonb DEFAULT '[]'::jsonb,
    forbidden_words_detected jsonb DEFAULT '[]'::jsonb,
    compliance_issues jsonb DEFAULT '[]'::jsonb,
    risk_level character varying(20),
    talk_time_ratio numeric DEFAULT 1.0,
    interruptions integer DEFAULT 0,
    silent_periods integer DEFAULT 0,
    call_quality_score numeric DEFAULT 7.0,
    quote_discussed boolean DEFAULT false,
    budget_mentioned boolean DEFAULT false,
    timeline_discussed boolean DEFAULT false,
    next_steps_agreed boolean DEFAULT false,
    follow_up_required boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_analytics OWNER TO vikasalagarsamy;

--
-- Name: call_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    conversion_indicators jsonb DEFAULT '[]'::jsonb,
    objection_patterns jsonb DEFAULT '[]'::jsonb,
    successful_techniques jsonb DEFAULT '[]'::jsonb,
    improvement_areas jsonb DEFAULT '[]'::jsonb,
    decision_factors jsonb DEFAULT '[]'::jsonb,
    pain_points jsonb DEFAULT '[]'::jsonb,
    preferences jsonb DEFAULT '[]'::jsonb,
    concerns jsonb DEFAULT '[]'::jsonb,
    market_trends jsonb DEFAULT '[]'::jsonb,
    competitive_mentions jsonb DEFAULT '[]'::jsonb,
    pricing_feedback jsonb DEFAULT '[]'::jsonb,
    service_feedback jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_insights OWNER TO vikasalagarsamy;

--
-- Name: call_transcriptions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_transcriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    task_id uuid,
    lead_id integer,
    client_name character varying(255) NOT NULL,
    sales_agent character varying(255) NOT NULL,
    phone_number character varying(20) NOT NULL,
    duration integer NOT NULL,
    recording_url text,
    transcript text NOT NULL,
    confidence_score numeric DEFAULT 0.8,
    language character varying(10) DEFAULT 'en'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    detected_language character varying(10),
    status character varying(20) DEFAULT 'processing'::character varying,
    notes text,
    call_direction character varying(20) DEFAULT 'outgoing'::character varying,
    call_status character varying(20) DEFAULT 'processing'::character varying
);


ALTER TABLE public.call_transcriptions OWNER TO vikasalagarsamy;

--
-- Name: call_triggers; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_triggers (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    phone_number character varying(20) NOT NULL,
    client_name character varying(255),
    task_id integer,
    triggered_at timestamp with time zone DEFAULT now(),
    executed_at timestamp with time zone,
    status character varying(20) DEFAULT 'pending'::character varying,
    response_data jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_triggers OWNER TO vikasalagarsamy;

--
-- Name: call_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.call_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.call_triggers_id_seq OWNER TO vikasalagarsamy;

--
-- Name: call_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.call_triggers_id_seq OWNED BY public.call_triggers.id;


--
-- Name: chat_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.chat_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone text NOT NULL,
    name text,
    message text NOT NULL,
    reply text NOT NULL,
    channel text DEFAULT 'whatsapp'::text,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE public.chat_logs OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.client_communication_timeline (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20),
    communication_type character varying(20) NOT NULL,
    communication_direction character varying(10) NOT NULL,
    content text,
    "timestamp" timestamp without time zone NOT NULL,
    employee_id integer,
    reference_id integer,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.client_communication_timeline OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.client_communication_timeline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_communication_timeline_id_seq OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.client_communication_timeline_id_seq OWNED BY public.client_communication_timeline.id;


--
-- Name: client_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.client_insights (
    id integer NOT NULL,
    client_name text NOT NULL,
    client_email text,
    client_phone text,
    sentiment_score numeric,
    engagement_level text,
    conversion_probability numeric,
    preferred_communication_method text,
    optimal_follow_up_time text,
    price_sensitivity text,
    decision_timeline_days integer,
    insights jsonb DEFAULT '{}'::jsonb NOT NULL,
    last_analyzed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.client_insights OWNER TO vikasalagarsamy;

--
-- Name: client_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.client_insights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_insights_id_seq OWNER TO vikasalagarsamy;

--
-- Name: client_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.client_insights_id_seq OWNED BY public.client_insights.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    client_code character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    company_id integer NOT NULL,
    contact_person character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50) NOT NULL,
    address text NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(100) NOT NULL,
    category character varying(20) NOT NULL,
    status character varying(20) NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    country_code character varying(10) DEFAULT '+91'::character varying,
    is_whatsapp boolean DEFAULT false,
    whatsapp_country_code character varying(10),
    whatsapp_number character varying(20),
    has_separate_whatsapp boolean DEFAULT false
);


ALTER TABLE public.clients OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: communications; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.communications (
    id integer NOT NULL,
    channel_type character varying(50) NOT NULL,
    message_id character varying(255) NOT NULL,
    sender_type character varying(50) NOT NULL,
    sender_id character varying(100),
    sender_name character varying(255),
    recipient_type character varying(50) NOT NULL,
    recipient_id character varying(100),
    recipient_name character varying(255),
    content_type character varying(50) NOT NULL,
    content_text text,
    content_metadata jsonb,
    business_context character varying(100),
    ai_processed boolean DEFAULT false,
    ai_priority_score numeric DEFAULT 0.0,
    sent_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.communications OWNER TO vikasalagarsamy;

--
-- Name: communications_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.communications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communications_id_seq OWNER TO vikasalagarsamy;

--
-- Name: communications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.communications_id_seq OWNED BY public.communications.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    registration_number character varying(100),
    tax_id character varying(100),
    address text,
    phone character varying(50),
    email character varying(255),
    website character varying(255),
    founded_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    company_code character varying(20)
);


ALTER TABLE public.companies OWNER TO vikasalagarsamy;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO vikasalagarsamy;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_partners; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.company_partners (
    company_id integer NOT NULL,
    partner_id integer NOT NULL,
    contract_details text,
    contract_start_date date,
    contract_end_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.company_partners OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.conversation_sessions (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20) NOT NULL,
    session_start timestamp without time zone NOT NULL,
    session_end timestamp without time zone,
    message_count integer DEFAULT 0,
    overall_sentiment character varying(20),
    business_outcome character varying(30),
    ai_summary text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.conversation_sessions OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.conversation_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversation_sessions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.conversation_sessions_id_seq OWNED BY public.conversation_sessions.id;


--
-- Name: deliverable_master; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.deliverable_master (
    id bigint NOT NULL,
    category text NOT NULL,
    type text NOT NULL,
    deliverable_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.deliverable_master OWNER TO vikasalagarsamy;

--
-- Name: deliverable_master_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.deliverable_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverable_master_id_seq OWNER TO vikasalagarsamy;

--
-- Name: deliverable_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.deliverable_master_id_seq OWNED BY public.deliverable_master.id;


--
-- Name: deliverables; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.deliverables (
    id integer NOT NULL,
    deliverable_cat character varying(50) NOT NULL,
    deliverable_type character varying(50) NOT NULL,
    deliverable_id integer,
    deliverable_name character varying(255) NOT NULL,
    process_name character varying(255) NOT NULL,
    has_customer boolean DEFAULT false,
    has_employee boolean DEFAULT false,
    has_qc boolean DEFAULT false,
    has_vendor boolean DEFAULT false,
    link character varying(255),
    sort_order integer DEFAULT 0,
    timing_type character varying(20) DEFAULT 'days'::character varying,
    tat integer,
    tat_value integer,
    buffer integer,
    skippable boolean DEFAULT false,
    employee jsonb,
    has_download_option boolean DEFAULT false,
    has_task_process boolean DEFAULT true,
    has_upload_folder_path boolean DEFAULT false,
    process_starts_from integer DEFAULT 0,
    status integer DEFAULT 1,
    on_start_template character varying(255),
    on_complete_template character varying(255),
    on_correction_template character varying(255),
    input_names jsonb,
    created_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    stream character varying(10),
    stage character varying(10),
    package_included jsonb DEFAULT '{"basic": false, "elite": false, "premium": false}'::jsonb,
    basic_price numeric,
    elite_price numeric,
    premium_price numeric
);


ALTER TABLE public.deliverables OWNER TO vikasalagarsamy;

--
-- Name: deliverables_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.deliverables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverables_id_seq OWNER TO vikasalagarsamy;

--
-- Name: deliverables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.deliverables_id_seq OWNED BY public.deliverables.id;


--
-- Name: department_instructions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.department_instructions (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instructions jsonb NOT NULL,
    status character varying(20) DEFAULT 'pending_approval'::character varying,
    created_by character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.department_instructions OWNER TO vikasalagarsamy;

--
-- Name: department_instructions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.department_instructions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_instructions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: department_instructions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.department_instructions_id_seq OWNED BY public.department_instructions.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    manager_id integer,
    parent_department_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.departments OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: designation_menu_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.designation_menu_permissions (
    id integer NOT NULL,
    designation_id integer NOT NULL,
    menu_item_id integer NOT NULL,
    can_view boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(20),
    updated_by character varying(20)
);


ALTER TABLE public.designation_menu_permissions OWNER TO vikasalagarsamy;

--
-- Name: designation_menu_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.designation_menu_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.designation_menu_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: designation_menu_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.designation_menu_permissions_id_seq OWNED BY public.designation_menu_permissions.id;


--
-- Name: designations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.designations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    department_id integer,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.designations OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.designations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.designations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.designations_id_seq OWNED BY public.designations.id;


--
-- Name: dynamic_menus; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.dynamic_menus (
    id integer NOT NULL,
    menu_id character varying(100) NOT NULL,
    label character varying(255) NOT NULL,
    href character varying(500) NOT NULL,
    icon character varying(100),
    description text,
    parent_id integer,
    sort_order integer DEFAULT 999,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dynamic_menus OWNER TO vikasalagarsamy;

--
-- Name: dynamic_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.dynamic_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dynamic_menus_id_seq OWNER TO vikasalagarsamy;

--
-- Name: dynamic_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.dynamic_menus_id_seq OWNED BY public.dynamic_menus.id;


--
-- Name: email_notification_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.email_notification_templates (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    name text NOT NULL,
    subject text NOT NULL,
    html_template text NOT NULL,
    text_template text NOT NULL,
    variables text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.email_notification_templates OWNER TO vikasalagarsamy;

--
-- Name: employee_companies; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employee_companies (
    id integer NOT NULL,
    employee_id integer,
    company_id integer,
    branch_id integer,
    allocation_percentage integer NOT NULL,
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    start_date date,
    end_date date,
    project_id uuid,
    status text DEFAULT 'active'::text
);


ALTER TABLE public.employee_companies OWNER TO vikasalagarsamy;

--
-- Name: employee_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employee_companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_companies_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employee_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employee_companies_id_seq OWNED BY public.employee_companies.id;


--
-- Name: employee_devices; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employee_devices (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    device_id character varying(255) NOT NULL,
    fcm_token text,
    device_name character varying(255),
    platform character varying(50) DEFAULT 'android'::character varying,
    app_version character varying(50),
    is_active boolean DEFAULT true,
    last_seen timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.employee_devices OWNER TO vikasalagarsamy;

--
-- Name: employee_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employee_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_devices_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employee_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employee_devices_id_seq OWNED BY public.employee_devices.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255),
    phone character varying(20),
    address text,
    city character varying(100),
    state character varying(100),
    zip_code character varying(20),
    country character varying(100),
    hire_date date,
    termination_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    department_id integer,
    designation_id integer,
    job_title character varying(100),
    home_branch_id integer,
    primary_company_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name character varying(255),
    username character varying(255),
    password_hash text,
    role_id integer,
    last_login timestamp without time zone,
    is_active boolean DEFAULT true
);


ALTER TABLE public.employees OWNER TO vikasalagarsamy;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.events OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_analytics (
    id integer NOT NULL,
    date date NOT NULL,
    total_messages integer DEFAULT 0,
    total_comments integer DEFAULT 0,
    total_mentions integer DEFAULT 0,
    total_story_mentions integer DEFAULT 0,
    new_leads_created integer DEFAULT 0,
    engagement_rate numeric DEFAULT 0.00,
    response_time_minutes integer DEFAULT 0,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_analytics OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_analytics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_analytics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_analytics_id_seq OWNED BY public.instagram_analytics.id;


--
-- Name: instagram_comments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_comments (
    id integer NOT NULL,
    comment_id character varying(255) NOT NULL,
    post_id character varying(255),
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    comment_text text,
    parent_comment_id character varying(255),
    is_from_client boolean DEFAULT true,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_comments OWNER TO vikasalagarsamy;

--
-- Name: instagram_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_comments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_comments_id_seq OWNED BY public.instagram_comments.id;


--
-- Name: instagram_interactions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_interactions (
    id integer NOT NULL,
    interaction_type character varying(50) NOT NULL,
    user_id character varying(255) NOT NULL,
    target_message_id character varying(255),
    content character varying(255),
    metadata jsonb DEFAULT '{}'::jsonb,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_interactions OWNER TO vikasalagarsamy;

--
-- Name: instagram_interactions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_interactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_interactions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_interactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_interactions_id_seq OWNED BY public.instagram_interactions.id;


--
-- Name: instagram_mentions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_mentions (
    id integer NOT NULL,
    mention_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    mention_text text,
    media_id character varying(255),
    permalink character varying(500),
    mention_type character varying(50) DEFAULT 'tag_mention'::character varying,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_mentions OWNER TO vikasalagarsamy;

--
-- Name: instagram_mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_mentions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_mentions_id_seq OWNED BY public.instagram_mentions.id;


--
-- Name: instagram_messages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_messages (
    id integer NOT NULL,
    message_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    to_user_id character varying(255) NOT NULL,
    content text,
    message_type character varying(50) DEFAULT 'text'::character varying,
    attachment_metadata jsonb DEFAULT '{}'::jsonb,
    is_from_client boolean DEFAULT true,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_messages OWNER TO vikasalagarsamy;

--
-- Name: instagram_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_messages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_messages_id_seq OWNED BY public.instagram_messages.id;


--
-- Name: instagram_story_mentions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_story_mentions (
    id integer NOT NULL,
    mention_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    story_text text,
    media_id character varying(255),
    story_url character varying(500),
    metadata jsonb DEFAULT '{}'::jsonb,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_story_mentions OWNER TO vikasalagarsamy;

--
-- Name: instagram_story_mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_story_mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_story_mentions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_story_mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_story_mentions_id_seq OWNED BY public.instagram_story_mentions.id;


--
-- Name: instruction_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instruction_approvals (
    id integer NOT NULL,
    instruction_id integer,
    approval_status character varying(20) NOT NULL,
    approved_by character varying(255),
    approved_at timestamp with time zone,
    comments text,
    submitted_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instruction_approvals OWNER TO vikasalagarsamy;

--
-- Name: instruction_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instruction_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instruction_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instruction_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instruction_approvals_id_seq OWNED BY public.instruction_approvals.id;


--
-- Name: lead_drafts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_drafts (
    id bigint NOT NULL,
    phone text NOT NULL,
    data jsonb NOT NULL,
    status text DEFAULT 'draft'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_drafts OWNER TO vikasalagarsamy;

--
-- Name: lead_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_drafts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_drafts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_drafts_id_seq OWNED BY public.lead_drafts.id;


--
-- Name: lead_followups; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_followups (
    id integer NOT NULL,
    lead_id integer NOT NULL,
    scheduled_at timestamp with time zone NOT NULL,
    completed_at timestamp with time zone,
    contact_method character varying(50) NOT NULL,
    interaction_summary text,
    status character varying(20) DEFAULT 'scheduled'::character varying NOT NULL,
    outcome text,
    notes text,
    priority character varying(10) DEFAULT 'medium'::character varying,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone,
    completed_by uuid,
    duration_minutes integer,
    follow_up_required boolean DEFAULT false,
    next_follow_up_date timestamp with time zone,
    followup_type text,
    workflow_stage character varying(50),
    quotation_id integer
);


ALTER TABLE public.lead_followups OWNER TO vikasalagarsamy;

--
-- Name: lead_followups_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_followups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_followups_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_followups_id_seq OWNED BY public.lead_followups.id;


--
-- Name: lead_sources; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_sources (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_sources OWNER TO vikasalagarsamy;

--
-- Name: lead_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_sources_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_sources_id_seq OWNED BY public.lead_sources.id;


--
-- Name: lead_task_performance; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_task_performance (
    id integer NOT NULL,
    lead_id integer NOT NULL,
    task_id integer NOT NULL,
    response_time_hours numeric,
    completion_time_hours numeric,
    sla_met boolean,
    revenue_impact numeric,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_task_performance OWNER TO vikasalagarsamy;

--
-- Name: lead_task_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_task_performance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_task_performance_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_task_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_task_performance_id_seq OWNED BY public.lead_task_performance.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    lead_number character varying(20) NOT NULL,
    company_id integer NOT NULL,
    branch_id integer,
    client_name character varying(255) NOT NULL,
    email character varying(255),
    country_code character varying(10),
    phone character varying(20),
    is_whatsapp boolean DEFAULT false,
    has_separate_whatsapp boolean DEFAULT false,
    whatsapp_country_code character varying(10),
    whatsapp_number character varying(20),
    notes text,
    status character varying(50) DEFAULT 'UNASSIGNED'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    assigned_to integer,
    lead_source character varying(100),
    location character varying(255),
    lead_source_id integer,
    rejection_reason text,
    rejected_at timestamp with time zone,
    rejected_by uuid,
    rejected_by_employee_id character varying(50),
    assigned_to_uuid uuid,
    previous_assigned_to integer,
    reassignment_date timestamp with time zone,
    reassignment_reason character varying(50),
    is_reassigned boolean DEFAULT false,
    reassigned_at timestamp with time zone,
    reassigned_by integer,
    reassigned_from_company_id integer,
    reassigned_from_branch_id integer,
    bride_name text,
    groom_name text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    expected_value numeric DEFAULT 0,
    last_contact_date timestamp without time zone,
    next_follow_up_date timestamp without time zone,
    conversion_stage character varying(50) DEFAULT 'new'::character varying,
    lead_score integer DEFAULT 50,
    tags text[],
    budget_range character varying(50),
    wedding_date date,
    venue_preference text,
    guest_count integer,
    description text,
    rejection_date timestamp without time zone
);


ALTER TABLE public.leads OWNER TO vikasalagarsamy;

--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leads_id_seq OWNER TO vikasalagarsamy;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: management_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.management_insights (
    id integer NOT NULL,
    insight_type text NOT NULL,
    employee_id text,
    priority text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    key_metrics jsonb DEFAULT '{}'::jsonb NOT NULL,
    suggested_questions jsonb DEFAULT '[]'::jsonb NOT NULL,
    recommended_actions jsonb DEFAULT '[]'::jsonb NOT NULL,
    confidence_score numeric NOT NULL,
    is_addressed boolean DEFAULT false NOT NULL,
    addressed_at timestamp with time zone,
    addressed_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone
);


ALTER TABLE public.management_insights OWNER TO vikasalagarsamy;

--
-- Name: management_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.management_insights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.management_insights_id_seq OWNER TO vikasalagarsamy;

--
-- Name: management_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.management_insights_id_seq OWNED BY public.management_insights.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.menu_items (
    id integer NOT NULL,
    parent_id integer,
    name character varying(100) NOT NULL,
    description text,
    icon character varying(50),
    path character varying(255),
    sort_order integer DEFAULT 0,
    is_visible boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    string_id character varying(100),
    section_name character varying(100),
    is_admin_only boolean DEFAULT false,
    badge_text character varying(50),
    badge_variant character varying(20) DEFAULT 'secondary'::character varying,
    is_new boolean DEFAULT false,
    category character varying(20) DEFAULT 'primary'::character varying
);


ALTER TABLE public.menu_items OWNER TO vikasalagarsamy;

--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.menu_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_items_id_seq OWNER TO vikasalagarsamy;

--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: menu_items_tracking; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.menu_items_tracking (
    id integer NOT NULL,
    menu_item_id integer NOT NULL,
    last_known_state jsonb NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.menu_items_tracking OWNER TO vikasalagarsamy;

--
-- Name: menu_items_tracking_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.menu_items_tracking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_items_tracking_id_seq OWNER TO vikasalagarsamy;

--
-- Name: menu_items_tracking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.menu_items_tracking_id_seq OWNED BY public.menu_items_tracking.id;


--
-- Name: message_analysis; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.message_analysis (
    id integer NOT NULL,
    message_id integer,
    sentiment character varying(20),
    sentiment_score numeric,
    intent character varying(50),
    urgency_level integer,
    key_topics text[],
    recommended_action text,
    confidence_score numeric,
    ai_model_version character varying(20) DEFAULT 'gpt-4'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.message_analysis OWNER TO vikasalagarsamy;

--
-- Name: message_analysis_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.message_analysis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_analysis_id_seq OWNER TO vikasalagarsamy;

--
-- Name: message_analysis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.message_analysis_id_seq OWNED BY public.message_analysis.id;


--
-- Name: ml_model_performance; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ml_model_performance (
    id integer NOT NULL,
    model_name text NOT NULL,
    model_version text NOT NULL,
    metric_type text NOT NULL,
    metric_value numeric NOT NULL,
    dataset_size integer NOT NULL,
    training_date timestamp with time zone NOT NULL,
    evaluation_date timestamp with time zone DEFAULT now() NOT NULL,
    is_production_model boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ml_model_performance OWNER TO vikasalagarsamy;

--
-- Name: ml_model_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ml_model_performance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ml_model_performance_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ml_model_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ml_model_performance_id_seq OWNED BY public.ml_model_performance.id;


--
-- Name: notification_batches; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_batches (
    id integer NOT NULL,
    user_id integer NOT NULL,
    notification_type character varying(100) NOT NULL,
    batch_key character varying(200) NOT NULL,
    last_sent timestamp with time zone DEFAULT now(),
    count integer DEFAULT 1,
    metadata jsonb
);


ALTER TABLE public.notification_batches OWNER TO vikasalagarsamy;

--
-- Name: notification_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.notification_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_batches_id_seq OWNER TO vikasalagarsamy;

--
-- Name: notification_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.notification_batches_id_seq OWNED BY public.notification_batches.id;


--
-- Name: notification_engagement; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_engagement (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id text NOT NULL,
    user_id uuid NOT NULL,
    event_type text NOT NULL,
    engagement_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notification_engagement OWNER TO vikasalagarsamy;

--
-- Name: notification_patterns; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_patterns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL,
    frequency integer DEFAULT 1,
    engagement_rate numeric DEFAULT 0.5,
    optimal_timing integer[] DEFAULT ARRAY[9, 14, 16],
    user_segments text[] DEFAULT ARRAY['general'::text],
    success_metrics jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notification_patterns OWNER TO vikasalagarsamy;

--
-- Name: notification_preferences; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_preferences (
    user_id uuid NOT NULL,
    email_notifications boolean DEFAULT true,
    push_notifications boolean DEFAULT true,
    permission_changes boolean DEFAULT true,
    role_assignments boolean DEFAULT true,
    admin_role_changes boolean DEFAULT true,
    security_permission_changes boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notification_preferences OWNER TO vikasalagarsamy;

--
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_recipients (
    notification_id integer NOT NULL,
    user_id uuid NOT NULL,
    is_read boolean DEFAULT false,
    is_dismissed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notification_recipients OWNER TO vikasalagarsamy;

--
-- Name: notification_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_rules (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    name text NOT NULL,
    trigger_type text NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb NOT NULL,
    recipients text[] DEFAULT '{}'::text[] NOT NULL,
    template_id text,
    enabled boolean DEFAULT true NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification_rules OWNER TO vikasalagarsamy;

--
-- Name: notification_settings; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_settings (
    user_id integer NOT NULL,
    email_enabled boolean DEFAULT true NOT NULL,
    in_app_enabled boolean DEFAULT true NOT NULL,
    overdue_alerts boolean DEFAULT true NOT NULL,
    approval_alerts boolean DEFAULT true NOT NULL,
    payment_alerts boolean DEFAULT true NOT NULL,
    automation_alerts boolean DEFAULT true NOT NULL,
    email_frequency text DEFAULT 'immediate'::text NOT NULL,
    quiet_hours_start time without time zone,
    quiet_hours_end time without time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification_settings OWNER TO vikasalagarsamy;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notifications (
    id text NOT NULL,
    type text NOT NULL,
    priority text DEFAULT 'medium'::text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    quotation_id integer,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    action_url text,
    action_label text,
    metadata jsonb,
    scheduled_for timestamp with time zone DEFAULT now(),
    ai_enhanced boolean DEFAULT false,
    recipient_role character varying(50),
    recipient_id integer,
    data jsonb,
    read_at timestamp with time zone,
    target_user uuid,
    employee_id integer
);


ALTER TABLE public.notifications OWNER TO vikasalagarsamy;

--
-- Name: partners; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.partners (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    contact_person character varying(200),
    email character varying(255),
    phone character varying(50),
    address text,
    partnership_type character varying(100),
    partnership_start_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.partners OWNER TO vikasalagarsamy;

--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partners_id_seq OWNER TO vikasalagarsamy;

--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.partners_id_seq OWNED BY public.partners.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    quotation_id integer,
    amount numeric NOT NULL,
    payment_type character varying(20) NOT NULL,
    payment_method character varying(50) NOT NULL,
    payment_reference character varying(100) NOT NULL,
    paid_by character varying(255) NOT NULL,
    status character varying(20) DEFAULT 'received'::character varying,
    received_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO vikasalagarsamy;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) NOT NULL,
    resource character varying(100),
    action character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'active'::character varying
);


ALTER TABLE public.permissions OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: personalization_learning; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.personalization_learning (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    interaction_type text NOT NULL,
    interaction_data jsonb NOT NULL,
    outcome_positive boolean,
    learning_weight numeric DEFAULT 1.0,
    context_tags text[] DEFAULT '{}'::text[],
    session_id text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.personalization_learning OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.post_sale_confirmations (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    confirmed_by_user_id uuid NOT NULL,
    confirmation_date timestamp without time zone DEFAULT now() NOT NULL,
    call_date date NOT NULL,
    call_time time without time zone NOT NULL,
    call_duration integer DEFAULT 30 NOT NULL,
    client_contact_person character varying(255) NOT NULL,
    confirmation_method character varying(50) DEFAULT 'phone'::character varying NOT NULL,
    services_confirmed jsonb DEFAULT '[]'::jsonb,
    deliverables_confirmed jsonb DEFAULT '[]'::jsonb,
    event_details_confirmed jsonb DEFAULT '{}'::jsonb,
    client_satisfaction_rating integer DEFAULT 5,
    client_expectations text NOT NULL,
    client_concerns text,
    additional_requests text,
    call_summary text NOT NULL,
    action_items text,
    follow_up_required boolean DEFAULT false,
    follow_up_date date,
    attachments jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.post_sale_confirmations OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.post_sale_confirmations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_sale_confirmations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.post_sale_confirmations_id_seq OWNED BY public.post_sale_confirmations.id;


--
-- Name: post_sales_workflows; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.post_sales_workflows (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instruction_id integer,
    client_name character varying(255) NOT NULL,
    status character varying(30) DEFAULT 'pending_confirmation'::character varying,
    instructions jsonb,
    confirmed_by character varying(255),
    confirmed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.post_sales_workflows OWNER TO vikasalagarsamy;

--
-- Name: post_sales_workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.post_sales_workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_sales_workflows_id_seq OWNER TO vikasalagarsamy;

--
-- Name: post_sales_workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.post_sales_workflows_id_seq OWNED BY public.post_sales_workflows.id;


--
-- Name: predictive_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.predictive_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    insight_type text NOT NULL,
    probability numeric NOT NULL,
    recommended_action text NOT NULL,
    trigger_conditions jsonb DEFAULT '{}'::jsonb,
    estimated_impact numeric DEFAULT 0,
    status text DEFAULT 'pending'::text,
    expires_at timestamp with time zone DEFAULT (now() + '7 days'::interval),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.predictive_insights OWNER TO vikasalagarsamy;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name character varying(255),
    avatar_url text,
    job_title character varying(255),
    department character varying(255),
    location character varying(255),
    phone character varying(50),
    bio text,
    employee_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.profiles OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.query_performance_logs (
    id integer NOT NULL,
    view_name text,
    rows_returned integer,
    execution_time_ms double precision,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.query_performance_logs OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.query_performance_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_performance_logs_id_seq OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.query_performance_logs_id_seq OWNED BY public.query_performance_logs.id;


--
-- Name: quotation_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_approvals (
    id integer NOT NULL,
    quotation_id integer,
    approval_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    approval_date timestamp without time zone,
    comments text,
    price_adjustments jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approver_user_id integer NOT NULL
);


ALTER TABLE public.quotation_approvals OWNER TO vikasalagarsamy;

--
-- Name: quotation_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_approvals_id_seq OWNED BY public.quotation_approvals.id;


--
-- Name: quotation_business_lifecycle; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_business_lifecycle (
    id integer NOT NULL,
    quotation_id integer,
    current_stage character varying(30) DEFAULT 'quotation_sent'::character varying NOT NULL,
    stage_history jsonb[],
    probability_score integer,
    last_client_interaction timestamp without time zone,
    next_follow_up_due timestamp without time zone,
    days_in_pipeline integer DEFAULT 0,
    revision_count integer DEFAULT 0,
    ai_insights text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.quotation_business_lifecycle OWNER TO vikasalagarsamy;

--
-- Name: quotation_business_lifecycle_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_business_lifecycle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_business_lifecycle_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_business_lifecycle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_business_lifecycle_id_seq OWNED BY public.quotation_business_lifecycle.id;


--
-- Name: quotation_edit_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_edit_approvals (
    id bigint NOT NULL,
    quotation_id bigint NOT NULL,
    requested_by integer NOT NULL,
    approved_by integer,
    original_data jsonb NOT NULL,
    modified_data jsonb NOT NULL,
    changes_summary text,
    edit_reason text,
    original_amount numeric DEFAULT 0,
    modified_amount numeric DEFAULT 0,
    amount_difference numeric DEFAULT 0,
    percentage_change numeric DEFAULT 0,
    approval_status character varying(20) DEFAULT 'pending'::character varying,
    approval_date timestamp with time zone,
    approval_comments text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_edit_approvals OWNER TO vikasalagarsamy;

--
-- Name: quotation_edit_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_edit_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_edit_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_edit_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_edit_approvals_id_seq OWNED BY public.quotation_edit_approvals.id;


--
-- Name: quotation_events; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_events (
    id integer NOT NULL,
    quotation_id integer,
    event_name character varying(255) NOT NULL,
    event_date timestamp with time zone NOT NULL,
    event_location character varying(255) NOT NULL,
    venue_name character varying(255) NOT NULL,
    start_time character varying(10) NOT NULL,
    end_time character varying(10) NOT NULL,
    expected_crowd character varying(100),
    selected_package character varying(20) NOT NULL,
    selected_services jsonb DEFAULT '[]'::jsonb,
    selected_deliverables jsonb DEFAULT '[]'::jsonb,
    service_overrides jsonb DEFAULT '{}'::jsonb,
    package_overrides jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_events OWNER TO vikasalagarsamy;

--
-- Name: quotation_events_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_events_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_events_id_seq OWNED BY public.quotation_events.id;


--
-- Name: quotation_predictions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_predictions (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    success_probability numeric NOT NULL,
    confidence_score numeric NOT NULL,
    prediction_factors jsonb DEFAULT '{}'::jsonb NOT NULL,
    model_version text DEFAULT 'v1.0'::text NOT NULL,
    predicted_at timestamp with time zone DEFAULT now() NOT NULL,
    actual_outcome text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quotation_predictions OWNER TO vikasalagarsamy;

--
-- Name: quotation_predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_predictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_predictions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_predictions_id_seq OWNED BY public.quotation_predictions.id;


--
-- Name: quotation_revisions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_revisions (
    id integer NOT NULL,
    original_quotation_id integer,
    revision_number integer NOT NULL,
    revised_quotation_data jsonb NOT NULL,
    revision_reason text NOT NULL,
    revised_by character varying(255) NOT NULL,
    status character varying(20) DEFAULT 'pending_approval'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_revisions OWNER TO vikasalagarsamy;

--
-- Name: quotation_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_revisions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_revisions_id_seq OWNED BY public.quotation_revisions.id;


--
-- Name: quotation_workflow_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_workflow_history (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    action character varying(50) NOT NULL,
    performed_at timestamp without time zone DEFAULT now() NOT NULL,
    comments text,
    performed_by integer NOT NULL
);


ALTER TABLE public.quotation_workflow_history OWNER TO vikasalagarsamy;

--
-- Name: quotation_workflow_history_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_workflow_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_workflow_history_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_workflow_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_workflow_history_id_seq OWNED BY public.quotation_workflow_history.id;


--
-- Name: quotations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotations (
    id integer NOT NULL,
    lead_id integer,
    follow_up_id integer,
    quotation_number character varying(50) NOT NULL,
    client_name character varying(255) NOT NULL,
    bride_name character varying(255) NOT NULL,
    groom_name character varying(255) NOT NULL,
    mobile character varying(50) NOT NULL,
    whatsapp character varying(50),
    alternate_mobile character varying(50),
    alternate_whatsapp character varying(50),
    email character varying(255) NOT NULL,
    default_package character varying(20) NOT NULL,
    total_amount numeric NOT NULL,
    status character varying(20) DEFAULT 'draft'::character varying,
    quotation_data jsonb NOT NULL,
    events_count integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    slug text,
    workflow_status character varying(50) DEFAULT 'draft'::character varying,
    client_verbal_confirmation_date timestamp without time zone,
    payment_received_date timestamp without time zone,
    payment_amount numeric,
    payment_reference character varying(100),
    confirmation_required boolean DEFAULT true,
    created_by integer NOT NULL,
    revision_notes text,
    client_feedback text,
    negotiation_history jsonb DEFAULT '[]'::jsonb,
    revision_count integer DEFAULT 0
);


ALTER TABLE public.quotations OWNER TO vikasalagarsamy;

--
-- Name: quotations_backup_before_migration; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotations_backup_before_migration (
    id integer,
    lead_id integer,
    follow_up_id integer,
    quotation_number character varying(50),
    client_name character varying(255),
    bride_name character varying(255),
    groom_name character varying(255),
    mobile character varying(50),
    whatsapp character varying(50),
    alternate_mobile character varying(50),
    alternate_whatsapp character varying(50),
    email character varying(255),
    default_package character varying(20),
    total_amount numeric,
    status character varying(20),
    created_by uuid,
    quotation_data jsonb,
    events_count integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    slug text,
    workflow_status character varying(50),
    client_verbal_confirmation_date timestamp without time zone,
    payment_received_date timestamp without time zone,
    payment_amount numeric,
    payment_reference character varying(100),
    confirmation_required boolean
);


ALTER TABLE public.quotations_backup_before_migration OWNER TO vikasalagarsamy;

--
-- Name: quotations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotations_id_seq OWNED BY public.quotations.id;


--
-- Name: quote_components; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_components (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    component_type character varying(50) NOT NULL,
    component_name character varying(255) NOT NULL,
    component_description text,
    unit_price numeric,
    quantity integer DEFAULT 1,
    subtotal numeric NOT NULL,
    metadata jsonb,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quote_components OWNER TO vikasalagarsamy;

--
-- Name: quote_components_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_components_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_components_id_seq OWNED BY public.quote_components.id;


--
-- Name: quote_deliverables_snapshot; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_deliverables_snapshot (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    deliverable_id integer NOT NULL,
    deliverable_name character varying(255) NOT NULL,
    deliverable_type character varying(50) NOT NULL,
    process_name character varying(255) NOT NULL,
    package_type character varying(20) NOT NULL,
    tat integer,
    timing_type character varying(20),
    sort_order integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quote_deliverables_snapshot OWNER TO vikasalagarsamy;

--
-- Name: quote_deliverables_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_deliverables_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_deliverables_snapshot_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_deliverables_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_deliverables_snapshot_id_seq OWNED BY public.quote_deliverables_snapshot.id;


--
-- Name: quote_services_snapshot; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_services_snapshot (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    service_id integer NOT NULL,
    service_name character varying(255) NOT NULL,
    package_type character varying(20) NOT NULL,
    locked_price numeric NOT NULL,
    quantity integer DEFAULT 1,
    subtotal numeric NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quote_services_snapshot OWNER TO vikasalagarsamy;

--
-- Name: quote_services_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_services_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_services_snapshot_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_services_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_services_snapshot_id_seq OWNED BY public.quote_services_snapshot.id;


--
-- Name: revenue_forecasts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.revenue_forecasts (
    id integer NOT NULL,
    forecast_period text NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    predicted_revenue numeric NOT NULL,
    confidence_interval_low numeric NOT NULL,
    confidence_interval_high numeric NOT NULL,
    contributing_factors jsonb DEFAULT '{}'::jsonb NOT NULL,
    model_metrics jsonb DEFAULT '{}'::jsonb NOT NULL,
    actual_revenue numeric,
    forecast_accuracy numeric,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.revenue_forecasts OWNER TO vikasalagarsamy;

--
-- Name: revenue_forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.revenue_forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revenue_forecasts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: revenue_forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.revenue_forecasts_id_seq OWNED BY public.revenue_forecasts.id;


--
-- Name: role_menu_access; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_menu_access (
    id integer NOT NULL,
    role_name character varying(100) NOT NULL,
    menu_id character varying(100) NOT NULL,
    has_access boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.role_menu_access OWNER TO vikasalagarsamy;

--
-- Name: role_menu_access_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_menu_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_menu_access_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_menu_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_menu_access_id_seq OWNED BY public.role_menu_access.id;


--
-- Name: role_menu_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_menu_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    can_view boolean DEFAULT false,
    can_add boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    description text,
    menu_string_id character varying(100) NOT NULL
);


ALTER TABLE public.role_menu_permissions OWNER TO vikasalagarsamy;

--
-- Name: role_menu_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_menu_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_menu_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_menu_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_menu_permissions_id_seq OWNED BY public.role_menu_permissions.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    role_id integer,
    permission_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'active'::character varying
);


ALTER TABLE public.role_permissions OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    title character varying(255),
    description text,
    department_id integer,
    responsibilities text[],
    required_skills text[],
    is_management boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_system_role boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    name text DEFAULT 'Unnamed Role'::text NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.roles OWNER TO vikasalagarsamy;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: sales_activities; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_activities (
    id integer NOT NULL,
    employee_id text NOT NULL,
    quotation_id integer,
    activity_type text NOT NULL,
    activity_description text NOT NULL,
    activity_outcome text,
    time_spent_minutes integer DEFAULT 0,
    activity_date timestamp with time zone DEFAULT now() NOT NULL,
    notes text,
    client_name text,
    deal_value numeric,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_activities OWNER TO vikasalagarsamy;

--
-- Name: sales_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_activities_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_activities_id_seq OWNED BY public.sales_activities.id;


--
-- Name: sales_performance_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_performance_metrics (
    id integer NOT NULL,
    employee_id text NOT NULL,
    metric_period date NOT NULL,
    quotations_created integer DEFAULT 0 NOT NULL,
    quotations_converted integer DEFAULT 0 NOT NULL,
    total_revenue_generated numeric DEFAULT 0 NOT NULL,
    avg_deal_size numeric DEFAULT 0 NOT NULL,
    avg_conversion_time_days integer DEFAULT 0 NOT NULL,
    follow_ups_completed integer DEFAULT 0 NOT NULL,
    client_meetings_held integer DEFAULT 0 NOT NULL,
    calls_made integer DEFAULT 0 NOT NULL,
    emails_sent integer DEFAULT 0 NOT NULL,
    conversion_rate numeric DEFAULT 0 NOT NULL,
    activity_score numeric DEFAULT 0 NOT NULL,
    performance_score numeric DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_performance_metrics OWNER TO vikasalagarsamy;

--
-- Name: sales_performance_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_performance_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_performance_metrics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_performance_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_performance_metrics_id_seq OWNED BY public.sales_performance_metrics.id;


--
-- Name: sales_team_members; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_team_members (
    id integer NOT NULL,
    employee_id text NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    phone text,
    role text NOT NULL,
    hire_date date NOT NULL,
    territory text,
    target_monthly numeric DEFAULT 0,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_team_members OWNER TO vikasalagarsamy;

--
-- Name: sales_team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_team_members_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_team_members_id_seq OWNED BY public.sales_team_members.id;


--
-- Name: sequence_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sequence_rules (
    id integer NOT NULL,
    sequence_template_id integer,
    rule_type character varying(100) NOT NULL,
    condition_field character varying(100) NOT NULL,
    condition_operator character varying(20) NOT NULL,
    condition_value text NOT NULL,
    action_type character varying(100) NOT NULL,
    action_data jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sequence_rules OWNER TO vikasalagarsamy;

--
-- Name: sequence_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sequence_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_rules_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sequence_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sequence_rules_id_seq OWNED BY public.sequence_rules.id;


--
-- Name: sequence_steps; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sequence_steps (
    id integer NOT NULL,
    sequence_template_id integer,
    step_number integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    icon character varying(50) DEFAULT 'target'::character varying,
    due_after_hours integer DEFAULT 24,
    priority character varying(20) DEFAULT 'medium'::character varying,
    is_conditional boolean DEFAULT false,
    condition_type character varying(100),
    condition_value text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sequence_steps OWNER TO vikasalagarsamy;

--
-- Name: sequence_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sequence_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_steps_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sequence_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sequence_steps_id_seq OWNED BY public.sequence_steps.id;


--
-- Name: service_packages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.service_packages (
    id integer NOT NULL,
    package_name character varying(50) NOT NULL,
    package_display_name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.service_packages OWNER TO vikasalagarsamy;

--
-- Name: service_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.service_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_packages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: service_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.service_packages_id_seq OWNED BY public.service_packages.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.services (
    id integer NOT NULL,
    servicename character varying(255) NOT NULL,
    status character varying(50) DEFAULT 'Active'::character varying NOT NULL,
    description text,
    category character varying(100),
    price numeric,
    unit character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    basic_price numeric,
    premium_price numeric,
    elite_price numeric,
    package_included jsonb DEFAULT '{"basic": false, "elite": false, "premium": false}'::jsonb
);


ALTER TABLE public.services OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_id_seq OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    supplier_code character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    contact_person character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    city character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    tax_id character varying(50),
    payment_terms character varying(100),
    website character varying(255),
    notes text,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    lead_time character varying(100)
);


ALTER TABLE public.suppliers OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_id_seq OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: system_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.system_logs (
    id integer NOT NULL,
    action character varying(100) NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.system_logs OWNER TO vikasalagarsamy;

--
-- Name: system_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.system_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_logs_id_seq OWNER TO vikasalagarsamy;

--
-- Name: system_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.system_logs_id_seq OWNED BY public.system_logs.id;


--
-- Name: task_generation_log; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_generation_log (
    id integer NOT NULL,
    lead_id integer,
    quotation_id integer,
    rule_triggered character varying(100) NOT NULL,
    task_id integer,
    success boolean NOT NULL,
    error_message text,
    triggered_by character varying(100),
    triggered_at timestamp with time zone DEFAULT now(),
    metadata jsonb
);


ALTER TABLE public.task_generation_log OWNER TO vikasalagarsamy;

--
-- Name: task_generation_log_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_generation_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_generation_log_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_generation_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_generation_log_id_seq OWNED BY public.task_generation_log.id;


--
-- Name: task_performance_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_performance_metrics (
    id integer NOT NULL,
    task_id integer NOT NULL,
    lead_id integer,
    quotation_id integer,
    assigned_to integer,
    created_date date NOT NULL,
    due_date date,
    completed_date date,
    days_to_complete integer,
    hours_estimated numeric,
    hours_actual numeric,
    efficiency_ratio numeric,
    priority_level character varying(20),
    was_overdue boolean DEFAULT false,
    quality_rating integer,
    revenue_impact numeric,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_performance_metrics OWNER TO vikasalagarsamy;

--
-- Name: task_performance_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_performance_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_performance_metrics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_performance_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_performance_metrics_id_seq OWNED BY public.task_performance_metrics.id;


--
-- Name: task_sequence_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_sequence_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) DEFAULT 'sales_followup'::character varying,
    is_active boolean DEFAULT true,
    created_by character varying(100) DEFAULT 'Admin'::character varying,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_sequence_templates OWNER TO vikasalagarsamy;

--
-- Name: task_sequence_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_sequence_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_sequence_templates_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_sequence_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_sequence_templates_id_seq OWNED BY public.task_sequence_templates.id;


--
-- Name: task_status_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_status_history (
    id integer NOT NULL,
    task_id integer NOT NULL,
    from_status character varying(20),
    to_status character varying(20) NOT NULL,
    changed_at timestamp with time zone DEFAULT now(),
    changed_by character varying(100),
    notes text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_status_history OWNER TO vikasalagarsamy;

--
-- Name: task_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_status_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_status_history_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_status_history_id_seq OWNED BY public.task_status_history.id;


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.team_members (
    team_id integer NOT NULL,
    employee_id integer NOT NULL,
    joined_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.team_members OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.team_performance_trends (
    id integer NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    total_quotations integer DEFAULT 0 NOT NULL,
    total_conversions integer DEFAULT 0 NOT NULL,
    total_revenue numeric DEFAULT 0 NOT NULL,
    team_conversion_rate numeric DEFAULT 0 NOT NULL,
    avg_deal_size numeric DEFAULT 0 NOT NULL,
    avg_sales_cycle_days integer DEFAULT 0 NOT NULL,
    top_performer_id text,
    underperformer_id text,
    performance_variance numeric DEFAULT 0 NOT NULL,
    team_activity_score numeric DEFAULT 0 NOT NULL,
    coaching_opportunities integer DEFAULT 0 NOT NULL,
    process_improvements_needed integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.team_performance_trends OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.team_performance_trends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_performance_trends_id_seq OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.team_performance_trends_id_seq OWNED BY public.team_performance_trends.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    department_id integer,
    team_lead_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.teams OWNER TO vikasalagarsamy;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO vikasalagarsamy;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: unified_role_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.unified_role_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    menu_string_id character varying(100) NOT NULL,
    can_view boolean DEFAULT false,
    can_add boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.unified_role_permissions OWNER TO vikasalagarsamy;

--
-- Name: unified_role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.unified_role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unified_role_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: unified_role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.unified_role_permissions_id_seq OWNED BY public.unified_role_permissions.id;


--
-- Name: user_accounts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_accounts (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    role_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    is_active boolean DEFAULT true,
    last_login timestamp without time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_accounts OWNER TO vikasalagarsamy;

--
-- Name: user_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.user_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_accounts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: user_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.user_accounts_id_seq OWNED BY public.user_accounts.id;


--
-- Name: user_activity_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_activity_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    activity_type text NOT NULL,
    activity_data jsonb DEFAULT '{}'::jsonb,
    session_id text,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_activity_history OWNER TO vikasalagarsamy;

--
-- Name: user_ai_profiles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_ai_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    personality_type text DEFAULT 'balanced'::text,
    communication_style text DEFAULT 'formal'::text,
    preferred_content_length text DEFAULT 'medium'::text,
    engagement_patterns jsonb DEFAULT '{}'::jsonb,
    response_time_patterns jsonb DEFAULT '{}'::jsonb,
    content_preferences jsonb DEFAULT '{}'::jsonb,
    ai_learning_enabled boolean DEFAULT true,
    personalization_score numeric DEFAULT 0.5,
    last_interaction timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_ai_profiles OWNER TO vikasalagarsamy;

--
-- Name: user_behavior_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_behavior_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    most_active_hours integer[] DEFAULT ARRAY[9, 10, 14, 15, 16],
    avg_response_time integer DEFAULT 1800,
    preferred_notification_types text[] DEFAULT ARRAY['system'::text],
    engagement_score numeric DEFAULT 0.5,
    timezone text DEFAULT 'UTC'::text,
    device_types text[] DEFAULT ARRAY['web'::text],
    last_activity timestamp with time zone DEFAULT now(),
    total_notifications_received integer DEFAULT 0,
    total_notifications_read integer DEFAULT 0,
    average_read_time integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_behavior_analytics OWNER TO vikasalagarsamy;

--
-- Name: user_engagement_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_engagement_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    notification_id text,
    engagement_type text NOT NULL,
    engagement_value numeric DEFAULT 1.0,
    channel text NOT NULL,
    device_type text,
    time_to_engage integer,
    context_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_engagement_analytics OWNER TO vikasalagarsamy;

--
-- Name: user_id_mapping; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_id_mapping (
    numeric_id integer NOT NULL,
    uuid uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_id_mapping OWNER TO vikasalagarsamy;

--
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text,
    include_name boolean DEFAULT false,
    channel_preferences text[] DEFAULT ARRAY['in_app'::text],
    quiet_hours_start integer DEFAULT 22,
    quiet_hours_end integer DEFAULT 8,
    frequency_limit integer DEFAULT 10,
    ai_optimization_enabled boolean DEFAULT true,
    personalization_level text DEFAULT 'medium'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_preferences OWNER TO vikasalagarsamy;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    employee_id character varying(50)
);


ALTER TABLE public.users OWNER TO vikasalagarsamy;

--
-- Name: vendors; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.vendors (
    id integer NOT NULL,
    vendor_code character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    contact_person character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    city character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    tax_id character varying(50),
    payment_terms character varying(100),
    website character varying(255),
    notes text,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.vendors OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendors_id_seq OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: whatsapp_config; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_phone_number_id text NOT NULL,
    access_token text NOT NULL,
    webhook_verify_token text NOT NULL,
    webhook_url text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.whatsapp_config OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_messages (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20) NOT NULL,
    message_text text NOT NULL,
    message_type character varying(20) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    interakt_message_id character varying(100),
    media_url text,
    media_type character varying(50),
    ai_analyzed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.whatsapp_messages OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.whatsapp_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.whatsapp_messages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.whatsapp_messages_id_seq OWNED BY public.whatsapp_messages.id;


--
-- Name: whatsapp_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_name text NOT NULL,
    template_type text NOT NULL,
    template_content text NOT NULL,
    variables jsonb DEFAULT '[]'::jsonb,
    language_code text DEFAULT 'en'::text,
    status text DEFAULT 'pending'::text,
    ai_optimized boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.whatsapp_templates OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.accounting_workflows ALTER COLUMN id SET DEFAULT nextval('public.accounting_workflows_id_seq'::regclass);


--
-- Name: action_recommendations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.action_recommendations ALTER COLUMN id SET DEFAULT nextval('public.action_recommendations_id_seq'::regclass);


--
-- Name: ai_behavior_settings id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_behavior_settings ALTER COLUMN id SET DEFAULT nextval('public.ai_behavior_settings_id_seq'::regclass);


--
-- Name: ai_communication_tasks id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks ALTER COLUMN id SET DEFAULT nextval('public.ai_communication_tasks_id_seq'::regclass);


--
-- Name: ai_configurations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_configurations ALTER COLUMN id SET DEFAULT nextval('public.ai_configurations_id_seq'::regclass);


--
-- Name: ai_prompt_templates id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_prompt_templates ALTER COLUMN id SET DEFAULT nextval('public.ai_prompt_templates_id_seq'::regclass);


--
-- Name: ai_tasks id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_tasks ALTER COLUMN id SET DEFAULT nextval('public.ai_tasks_id_seq'::regclass);


--
-- Name: branches id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);


--
-- Name: business_trends id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.business_trends ALTER COLUMN id SET DEFAULT nextval('public.business_trends_id_seq'::regclass);


--
-- Name: call_triggers id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_triggers ALTER COLUMN id SET DEFAULT nextval('public.call_triggers_id_seq'::regclass);


--
-- Name: client_communication_timeline id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_communication_timeline ALTER COLUMN id SET DEFAULT nextval('public.client_communication_timeline_id_seq'::regclass);


--
-- Name: client_insights id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_insights ALTER COLUMN id SET DEFAULT nextval('public.client_insights_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: communications id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.communications ALTER COLUMN id SET DEFAULT nextval('public.communications_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: conversation_sessions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.conversation_sessions ALTER COLUMN id SET DEFAULT nextval('public.conversation_sessions_id_seq'::regclass);


--
-- Name: deliverable_master id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverable_master ALTER COLUMN id SET DEFAULT nextval('public.deliverable_master_id_seq'::regclass);


--
-- Name: deliverables id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverables ALTER COLUMN id SET DEFAULT nextval('public.deliverables_id_seq'::regclass);


--
-- Name: department_instructions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.department_instructions ALTER COLUMN id SET DEFAULT nextval('public.department_instructions_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: designation_menu_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions ALTER COLUMN id SET DEFAULT nextval('public.designation_menu_permissions_id_seq'::regclass);


--
-- Name: designations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations ALTER COLUMN id SET DEFAULT nextval('public.designations_id_seq'::regclass);


--
-- Name: dynamic_menus id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.dynamic_menus ALTER COLUMN id SET DEFAULT nextval('public.dynamic_menus_id_seq'::regclass);


--
-- Name: employee_companies id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies ALTER COLUMN id SET DEFAULT nextval('public.employee_companies_id_seq'::regclass);


--
-- Name: employee_devices id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_devices ALTER COLUMN id SET DEFAULT nextval('public.employee_devices_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: instagram_analytics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_analytics ALTER COLUMN id SET DEFAULT nextval('public.instagram_analytics_id_seq'::regclass);


--
-- Name: instagram_comments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_comments ALTER COLUMN id SET DEFAULT nextval('public.instagram_comments_id_seq'::regclass);


--
-- Name: instagram_interactions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_interactions ALTER COLUMN id SET DEFAULT nextval('public.instagram_interactions_id_seq'::regclass);


--
-- Name: instagram_mentions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_mentions ALTER COLUMN id SET DEFAULT nextval('public.instagram_mentions_id_seq'::regclass);


--
-- Name: instagram_messages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_messages ALTER COLUMN id SET DEFAULT nextval('public.instagram_messages_id_seq'::regclass);


--
-- Name: instagram_story_mentions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_story_mentions ALTER COLUMN id SET DEFAULT nextval('public.instagram_story_mentions_id_seq'::regclass);


--
-- Name: instruction_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instruction_approvals ALTER COLUMN id SET DEFAULT nextval('public.instruction_approvals_id_seq'::regclass);


--
-- Name: lead_drafts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_drafts ALTER COLUMN id SET DEFAULT nextval('public.lead_drafts_id_seq'::regclass);


--
-- Name: lead_followups id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_followups ALTER COLUMN id SET DEFAULT nextval('public.lead_followups_id_seq'::regclass);


--
-- Name: lead_sources id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_sources ALTER COLUMN id SET DEFAULT nextval('public.lead_sources_id_seq'::regclass);


--
-- Name: lead_task_performance id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_task_performance ALTER COLUMN id SET DEFAULT nextval('public.lead_task_performance_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: management_insights id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.management_insights ALTER COLUMN id SET DEFAULT nextval('public.management_insights_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: menu_items_tracking id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items_tracking ALTER COLUMN id SET DEFAULT nextval('public.menu_items_tracking_id_seq'::regclass);


--
-- Name: message_analysis id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.message_analysis ALTER COLUMN id SET DEFAULT nextval('public.message_analysis_id_seq'::regclass);


--
-- Name: ml_model_performance id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ml_model_performance ALTER COLUMN id SET DEFAULT nextval('public.ml_model_performance_id_seq'::regclass);


--
-- Name: notification_batches id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_batches ALTER COLUMN id SET DEFAULT nextval('public.notification_batches_id_seq'::regclass);


--
-- Name: partners id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.partners ALTER COLUMN id SET DEFAULT nextval('public.partners_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: post_sale_confirmations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sale_confirmations ALTER COLUMN id SET DEFAULT nextval('public.post_sale_confirmations_id_seq'::regclass);


--
-- Name: post_sales_workflows id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sales_workflows ALTER COLUMN id SET DEFAULT nextval('public.post_sales_workflows_id_seq'::regclass);


--
-- Name: query_performance_logs id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.query_performance_logs ALTER COLUMN id SET DEFAULT nextval('public.query_performance_logs_id_seq'::regclass);


--
-- Name: quotation_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_approvals ALTER COLUMN id SET DEFAULT nextval('public.quotation_approvals_id_seq'::regclass);


--
-- Name: quotation_business_lifecycle id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_business_lifecycle ALTER COLUMN id SET DEFAULT nextval('public.quotation_business_lifecycle_id_seq'::regclass);


--
-- Name: quotation_edit_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_edit_approvals ALTER COLUMN id SET DEFAULT nextval('public.quotation_edit_approvals_id_seq'::regclass);


--
-- Name: quotation_events id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_events ALTER COLUMN id SET DEFAULT nextval('public.quotation_events_id_seq'::regclass);


--
-- Name: quotation_predictions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_predictions ALTER COLUMN id SET DEFAULT nextval('public.quotation_predictions_id_seq'::regclass);


--
-- Name: quotation_revisions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_revisions ALTER COLUMN id SET DEFAULT nextval('public.quotation_revisions_id_seq'::regclass);


--
-- Name: quotation_workflow_history id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_workflow_history ALTER COLUMN id SET DEFAULT nextval('public.quotation_workflow_history_id_seq'::regclass);


--
-- Name: quotations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations ALTER COLUMN id SET DEFAULT nextval('public.quotations_id_seq'::regclass);


--
-- Name: quote_components id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_components ALTER COLUMN id SET DEFAULT nextval('public.quote_components_id_seq'::regclass);


--
-- Name: quote_deliverables_snapshot id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_deliverables_snapshot ALTER COLUMN id SET DEFAULT nextval('public.quote_deliverables_snapshot_id_seq'::regclass);


--
-- Name: quote_services_snapshot id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_services_snapshot ALTER COLUMN id SET DEFAULT nextval('public.quote_services_snapshot_id_seq'::regclass);


--
-- Name: revenue_forecasts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.revenue_forecasts ALTER COLUMN id SET DEFAULT nextval('public.revenue_forecasts_id_seq'::regclass);


--
-- Name: role_menu_access id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_access ALTER COLUMN id SET DEFAULT nextval('public.role_menu_access_id_seq'::regclass);


--
-- Name: role_menu_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_menu_permissions_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: sales_activities id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_activities ALTER COLUMN id SET DEFAULT nextval('public.sales_activities_id_seq'::regclass);


--
-- Name: sales_performance_metrics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_performance_metrics ALTER COLUMN id SET DEFAULT nextval('public.sales_performance_metrics_id_seq'::regclass);


--
-- Name: sales_team_members id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_team_members ALTER COLUMN id SET DEFAULT nextval('public.sales_team_members_id_seq'::regclass);


--
-- Name: sequence_rules id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_rules ALTER COLUMN id SET DEFAULT nextval('public.sequence_rules_id_seq'::regclass);


--
-- Name: sequence_steps id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_steps ALTER COLUMN id SET DEFAULT nextval('public.sequence_steps_id_seq'::regclass);


--
-- Name: service_packages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.service_packages ALTER COLUMN id SET DEFAULT nextval('public.service_packages_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: system_logs id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.system_logs ALTER COLUMN id SET DEFAULT nextval('public.system_logs_id_seq'::regclass);


--
-- Name: task_generation_log id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_generation_log ALTER COLUMN id SET DEFAULT nextval('public.task_generation_log_id_seq'::regclass);


--
-- Name: task_performance_metrics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_performance_metrics ALTER COLUMN id SET DEFAULT nextval('public.task_performance_metrics_id_seq'::regclass);


--
-- Name: task_sequence_templates id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_sequence_templates ALTER COLUMN id SET DEFAULT nextval('public.task_sequence_templates_id_seq'::regclass);


--
-- Name: task_status_history id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_status_history ALTER COLUMN id SET DEFAULT nextval('public.task_status_history_id_seq'::regclass);


--
-- Name: team_performance_trends id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_performance_trends ALTER COLUMN id SET DEFAULT nextval('public.team_performance_trends_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: unified_role_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.unified_role_permissions ALTER COLUMN id SET DEFAULT nextval('public.unified_role_permissions_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts ALTER COLUMN id SET DEFAULT nextval('public.user_accounts_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: whatsapp_messages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_messages ALTER COLUMN id SET DEFAULT nextval('public.whatsapp_messages_id_seq'::regclass);


--
-- Name: designation_menu_permissions designation_menu_permissions_designation_id_menu_item_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_designation_id_menu_item_id_key UNIQUE (designation_id, menu_item_id);


--
-- Name: designation_menu_permissions designation_menu_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_pkey PRIMARY KEY (id);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- Name: employees employees_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_employee_id_key UNIQUE (employee_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: designation_menu_permissions designation_menu_permissions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.employees(employee_id);


--
-- Name: designation_menu_permissions designation_menu_permissions_designation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_designation_id_fkey FOREIGN KEY (designation_id) REFERENCES public.designations(id) ON DELETE CASCADE;


--
-- Name: designation_menu_permissions designation_menu_permissions_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: designation_menu_permissions designation_menu_permissions_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designation_menu_permissions
    ADD CONSTRAINT designation_menu_permissions_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.employees(employee_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: vikasalagarsamy
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

